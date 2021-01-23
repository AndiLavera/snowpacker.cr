require "../src/snowpacker"
require "spec"

Spec.before_each do
  if instance = Snowpacker::Engine.instance
    instance.flush
  end
end
