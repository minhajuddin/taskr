require File.join File.dirname(__FILE__), './spec_helper'
require "fakefs/safe"

describe Scheduler do
  describe "#run" do

    before(:each) do
      FakeFS.activate!
      write_test_taskr_file
    end

    it "should remove :hidden tag from a daily task in the first run" do
      list = TaskList.new
      tasks = list.search(":daily")
      tasks.each do |t|
        t.tags.should_not include(':hidden')
      end
    end

    it "should not remove :hidden tag from a daily task in subsequent runs" do
      list = TaskList.new
      list.search(":daily").each{|t| t.tags << ':hidden'}
      list.save

      list = TaskList.new
      tasks = list.search(":daily")
      tasks.each do |t|
        t.tags.should include(':hidden')
      end
    end

    after(:each) do
      FakeFS.deactivate!
    end

  end

end
