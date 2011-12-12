require File.join File.dirname(__FILE__), './spec_helper'
require "fakefs/safe"

describe Configuration do

  describe ".load without config" do
    before(:each) do
      FakeFS.activate!
    end
    it "should load defaults" do
      Configuration.load
      Configuration.config.attributes[:list_size].should == 20
    end

    after(:each) do
      FakeFS.deactivate!
    end

  end

  describe ".load with config" do

    before(:each) do
      example_config = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'examples', 'taskr_config.rb')
      Configuration.load(example_config)
    end

    it "should load config values" do
      Configuration.config.attributes[:list_size].should == 25
    end
  end


end
