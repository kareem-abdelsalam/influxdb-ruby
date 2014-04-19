require 'spec_helper'
require 'logger'

describe InfluxDB::Logging do
  class LoggerTest
    include InfluxDB::Logging

    def write_to_log(level, message)
      log(level, message)
    end

  end

  before { @old_logger = InfluxDB::Logging.logger }
  after { InfluxDB::Logging.logger = @old_logger }

  it "has a default logger" do
    expect(InfluxDB::Logging.logger).to be_a(Logger)
  end

  it "allows setting of a logger" do
    new_logger = Logger.new(STDOUT)
    InfluxDB::Logging.logger = new_logger
    expect(InfluxDB::Logging.logger).to eq(new_logger)
  end

  context "when included in classes" do

    subject { LoggerTest.new }

    it "logs" do
      expect(InfluxDB::Logging.logger).to receive(:debug).with(an_instance_of(String)).once
      subject.write_to_log(:debug, 'test')
    end
  end
end
