class TaskList

  def initialize
    @lines = File.readlines(Filepath).map{|x| x.chomp.strip}.reject{|x| x.empty?}
    @tasks = @lines.map{|x| Task.parse(x)}.sort_by{|x| [x.priority, x.raw_time]}
  end

  def list(num = 5)
    print num == :all ? @tasks : @tasks.select{|x| x.visible?}.take(num)
  end

  def search(q)
    print @tasks.select{|x| x.raw =~ /#{q}/i}
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
    File.open(Filepath, 'a') {|f| f.puts "#{Time.now.strftime "%Y%m%d%H%M%S"} #{task.strip}"}
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
    tasks.each{|x| @tasks.delete(x)}
    save

    File.open(Filepath+".done", 'a') do |f|
      tasks.each{|task| f.puts "#{Time.now.strftime "%Y%m%d%H%M%S"} #{task.serialize}" }
    end
    puts tasks
  end

  def save
    task_data = @tasks.map{|x| x.serialize }.join("\n")
    File.open(Filepath, 'w') {|f| f.puts task_data}
  end

  def xmobar
    puts "(#{@tasks.find_all(&:visible?).count}/#{@tasks.count}) #{@tasks.find_all{|x| x.tags.include?(':tray') && x.visible? }.map{|x| x.text[0..20] + '.. '}.join(':')}"
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

  def show(id)
    print find(id)
  end

  def tagify(tags)
    tags.map do |tag|
      tag =~ /^:.+/ ? tag : ":#{tag}"
    end
  end

end
