require File.join File.dirname(__FILE__), './spec_helper'
require "fakefs/safe"

describe TaskList do

  describe "#delete" do

    before(:each) do
      FakeFS.activate!
      write_test_taskr_file
    end

    it "should add :hidden tag to recurring tasks" do
      list = TaskList.new
      tasks = list.search(":daily")

      list.delete(tasks.map(&:id))

      tasks.each do |t|
        t.tags.should include(':hidden')
      end

    end

    after(:each) do
      FakeFS.deactivate!
    end

  end

end
