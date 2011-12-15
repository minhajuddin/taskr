class TaskList

  def initialize
    @lines = File.readlines(Configuration.tasks_file_path).map{|x| x.chomp.strip}.reject{|x| x.empty?}
    @tasks = @lines.map{|x| Task.parse(x)}.sort_by{|x| [-x.priority, x.raw_time]} #TODO: should allow users to configure the sort order
    Scheduler.new(self).materialize_recurring_tasks
  end

  def visible_tasks
    @tasks.select{|x| x.visible?}
  end

  def list(num = 5)
    print num == :all ? @tasks : visible_tasks.take(num)
  end

  def search(q)
    @tasks.select{|x| x.raw =~ /#{q}/i}
  end

  def print(tasks)
    #TODO: should say listing (5/25) tasks
    puts "(#{tasks.count.to_s.colorize(:red)}) tasks"
    puts '---------------------'.colorize(:blue)
    tasks.each do |t|
      puts t
    end
  end

  def append(task)
    #TODO: decipher special tags like :today, :tomorrow
    File.open(Configuration.tasks_file_path, 'a') {|f| f.puts "#{Time.now.strftime "%Y%m%d%H%M%S"} #{task.strip}"}
  end

  def tag(ids, tags)
    tasks = find(ids)
    tags = tagify(tags)

    tasks.each {|task| task.tags += tags }
    save

    print tasks
  end

  def untag(ids, tags)
    tasks = find(ids)
    tags = tagify(tags)

    tasks.each {|task| task.tags -= tags }

    save
    print tasks
  end

  def delete(ids)
    tasks = find(ids)
    deleted_tasks = []
    tasks.each do|t|
      if t.recurring?
        t.tags << ':hidden'
      else
        deleted_tasks << @tasks.delete(t)
      end
    end
    save

    File.open(Configuration.completed_tasks_file_path, 'a') do |f|
      deleted_tasks.each{|task| f.puts "#{Time.now.strftime "%Y%m%d%H%M%S"} #{task.serialize}" }
    end
    tasks
  end

  def save
    task_data = @tasks.map{|x| x.serialize }.join("\n")
    File.open(Configuration.tasks_file_path, 'w') {|f| f.puts task_data}
  end

  def tasks
    @tasks
  end

  def find(ids)
    tasks = @tasks.find_all{|x| ids.include?(x.id)}
    return tasks if tasks && !tasks.empty?
    puts 'task(s) not found'.colorize(:red)
    exit
  end

  def ids(id)
    ids = visible_tasks.map{|x| x.id}
    return ids if id.nil? || id.strip.empty?
    if id =~ /,/
      all_ids = id.split(',')
      first_ids = all_ids[0..-2].join(',')
      last_id = all_ids.last
      ids.find_all{|x| x =~ /^#{last_id}/}.map{|x| "#{first_ids},#{x}"}
    else
      ids.find_all{|x| x =~ /^#{id}/}
    end
  end

  def tags(tag)
    @tasks.map{|x| x.tags}.flatten.find_all{|x| x=~ /^#{tag}/}
  end

  def tagify(tags)
    tags.map do |tag|
      tag = tag.strip
      if tag.empty?
        nil
      elsif tag =~ /^:.+/
        tag
      else
        ":#{tag}"
      end
    end.compact
  end

end
