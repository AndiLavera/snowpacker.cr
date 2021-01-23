@[ADI::Register]
struct StaticFileListener
  include AED::EventListenerInterface

  # This could be part of the config object.
  private BUILD_DIR = Path.new(Snowpacker.config.build_dir).expand
  private ASSET_DIR = Snowpacker.config.env == "development" ? Path.new("src/assets").expand : BUILD_DIR

  def self.subscribed_events : AED::SubscribedEvents
    AED::SubscribedEvents{
      ART::Events::Request => 253,
    }
  end

  # In the future you'd probably use this to resolve your related configuration obj.
  # def initialize(@configuration_resolver : ACF::ConfigurationResolverInterface); end

  def call(event : ART::Events::Request, _dispatcher : AED::EventDispatcherInterface) : Nil
    # TODO: Fallback if the request method isn't intended for files.
    return unless event.request.method.in? "GET", "HEAD"
    return unless event.request.path.matches? Snowpacker::ASSET_REGEX

    original_path = event.request.path
    is_dir_path = original_path.ends_with? '/'
    request_path = URI.decode original_path

    # File path cannot contains '\0' (NUL) because all filesystem I know
    # don't accept '\0' character as file name.
    if request_path.includes? '\0'
      raise ART::Exceptions::BadRequest.new "File path cannot contain NUL bytes."
    end

    request_path = Path.posix request_path
    expanded_path = request_path.expand "/"

    # Ensure the file exists within the projects asset path. If it does not,
    # snowpack didn't include it.
    asset_file_path = ASSET_DIR.join expanded_path.to_kind Path::Kind.native

    is_dir = Dir.exists? asset_file_path
    is_file = !is_dir && File.exists? asset_file_path

    if request_path != expanded_path || is_dir && !is_dir_path
      redirect_path = expanded_path
      if is_dir && !is_dir_path
        redirect_path = expanded_path.join ""
      end

      return event.response = ART::RedirectResponse.new redirect_path.to_s
    elsif is_file
      # If we are in development & the file exists within the assets folder,
      # redirect to the snowpack dev server. Otherwise we skip this and fetch
      # the asset from the public dir.
      if Snowpacker.config.env == "development"
        return event.response = ART::RedirectResponse.new(
          File.join({"http://localhost:8080", request_path})
        )
      end

      # Assumes the assets are built and sitting in the public directory.
      file_path = BUILD_DIR.join expanded_path.to_kind Path::Kind.native

      headers = HTTP::Headers.new

      last_modified = self.modification_time(file_path)
      self.add_cache_headers(headers, last_modified)

      if self.cache_request?(event.request, headers, last_modified)
        return event.response = ART::Response.new status: HTTP::Status::NOT_MODIFIED
      end

      headers["content-type"] = MIME.from_filename(file_path.to_s, "application/octet-stream")

      # Checks if pre-gzipped file can be served
      if event.request.headers.includes_word?("accept-encoding", "gzip")
        gz_file_path = "#{file_path}.gz"

        if File.exists?(gz_file_path) &&
           # Allow small time drift. In some file systems, using `gz --keep` to
           # compress the file will keep the modification time of the original file
           # but truncating some decimals
           last_modified - modification_time(gz_file_path) < 1.millisecond
          # Overwrite file_path with new path
          file_path = gz_file_path

          headers["content-Encoding"] = "gzip"
        end
      end

      headers["content-length"] = File.size(file_path).to_s

      event.response = ART::StreamedResponse.new headers: headers do |io|
        File.open(file_path) do |file|
          IO.copy file, io
        end
      end
    end
  end

  private def add_cache_headers(response_headers : HTTP::Headers, last_modified : Time) : Nil
    response_headers["etag"] = self.etag(last_modified)
    response_headers["last-modified"] = HTTP.format_time(last_modified)
  end

  private def cache_request?(request : HTTP::Request, response_headers : HTTP::Headers, last_modified : Time) : Bool
    # According to RFC 7232:
    # A recipient must ignore If-Modified-Since if the request contains an If-None-Match header field
    if if_none_match = request.if_none_match
      match = {"*", response_headers["etag"]}
      if_none_match.any? { |etag| match.includes?(etag) }
    elsif if_modified_since = request.headers["if-modified-since"]?
      header_time = HTTP.parse_time(if_modified_since)
      # File mtime probably has a higher resolution than the header value.
      # An exact comparison might be slightly off, so we add 1s padding.
      # Static files should generally not be modified in subsecond intervals, so this is perfectly safe.
      # This might be replaced by a more sophisticated time comparison when it becomes available.
      !!(header_time && last_modified <= header_time + 1.second)
    else
      false
    end
  end

  private def etag(modification_time)
    %{W/"#{modification_time.to_unix}"}
  end

  private def modification_time(file_path)
    File.info(file_path).modification_time
  end
end
