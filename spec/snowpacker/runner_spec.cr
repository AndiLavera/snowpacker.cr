require "../spec_helper"

module Snowpacker
  describe Runner do
    it "can run dev" do
      Engine.configure do |config|
        config.config_path = "spec"
        config.enabled = true
      end

      begin
        process = Engine.run
        process.should_not be_nil
      ensure
        process.signal(Signal::KILL) if process
      end
    end

    it "can handle tcp in use" do
      Engine.configure do |config|
        config.config_path = "spec"
        config.enabled = true
      end

      begin
        sleep 2 # Wait for any process to die
        process = Engine.run
        sleep 3 # Wait for the process to turn on
        process2 = Engine.run

        process.should_not be_nil
        process2.should be_nil
      ensure
        process.signal(Signal::KILL) if process
        process2.signal(Signal::KILL) if process2
      end
    end
  end
end
