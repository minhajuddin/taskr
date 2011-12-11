require File.join File.dirname(__FILE__), './spec_helper'

describe Task do
  describe "#parse" do

    it "should set the priority to 3 when it has +++ in it" do
     Task.parse("20110303222222 awesome task +++").priority.should == 3
    end

    it "should set the priority to -3 when it has --- in it" do
      Task.parse("20110303222222 awesome task ---").priority.should == -3
    end

    it "should words starting with a colon(:) as tags" do
      task = Task.parse("20110303222222 This is an :awesome :meta-task :urgent :sys:intern")
      task.tags.should include(':awesome', ':urgent', ':awesome', ':meta-task', ":sys:intern")
    end

    it "transforms :today to the current date" do
      date_tag = Time.now.strftime(":%Y%m%d")
      Task.parse("20110303222222 awesome task :today").tags.include?(date_tag)
    end

  end

end
