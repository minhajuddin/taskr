class Scheduler
  def initialize(list)
    @list = list
  end

  def materialize_recurring_tasks
    return if previously_materialized?

    @list.search(":daily").each do |task|
      task.tags.delete(":hidden")
    end
    @list.save

    write_flag_file
  end

  #TODO: should move this to some configuration
  def taskr_dir
    File.dirname(Filepath)
  end

  def flag_file
    File.join(taskr_dir, 'tmp', Time.now.strftime("%Y%m%d"))
  end

  def write_flag_file
    FileUtils.touch(flag_file)
  end

  def previously_materialized?
    File.exists?(flag_file)
  end
end
