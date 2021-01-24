require "../spec_helper"
require "http/server"

module Snowpacker
  describe Utils do
    it "can detect if a port is in use" do
      Engine.configure do |config|
        config.config_path = "spec"
        config.enabled = true
      end

      begin
        sleep 1 # Wait for any process to die
        Utils.detect_port!.should be_true
        process = Engine.run
        sleep 2 # Wait for the process to turn on

        Utils.detect_port!.should be_false
      ensure
        process.signal(Signal::KILL) if process
      end
    end
  end
end
