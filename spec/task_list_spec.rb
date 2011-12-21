require File.join File.dirname(__FILE__), './spec_helper'
require "fakefs/safe"

describe TaskList do


  before(:each) do
    FakeFS.activate!
    load_test_config_file
    write_test_taskr_file
  end

  describe "#delete" do

    it "should add :hidden tag to recurring tasks" do

      list = TaskList.new
      tasks = list.search(":daily")

      puts "deleting #{tasks.count} tasks"
      list.delete(tasks.map(&:id))

      tasks.each do |t|
        t.tags.should include(':hidden')
      end

    end

  end

  describe "#tasks" do

    it "should sort tasks based on priority" do
      list = TaskList.new

      list.tasks.each_cons(2).each do |t1, t2|
        t1.priority.should >= t2.priority
      end

    end

  end

  after(:each) do
    FakeFS.deactivate!
  end

end
