module Taskr
  class Runner

    def self.edit_file(file_path)
      system("#{Configuration.editor} #{file_path}")
    end

    def self.execute

      tl = TaskList.new

      optparse = OptionParser.new do |opts|

        opts.banner =<<EOS
Usage: taskr [options]
  Two of the most used options are -l and -a,
  and you can use these options without the switches.

  e.g.
    $ taskr awesome task here hurray for no switches
      #adds the task to the list and is equivalent to taskr -a awes..
    $ taskr
      #lists all the tasks and is equivalent to 'taskr -l'

Options:
EOS

        opts.on('-a', '--add TASK', :NONE, 'Add task to the list') do
          tl.append(ARGV.join(' '))
          exit
        end
        opts.on('-l', '--list [NUM]', Integer, 'List all the tasks') do |num|
          tl.list(num||Configuration.val(:list_size))
          exit
        end
        opts.on('-L','--list-all' ,'List all the tasks' ) do
          tl.list(:all)
          exit
        end
        opts.on('-d','--delete id1,id2,..', Array,'Delete tasks(s)' ) do |ids|
          puts "deleted:"
          tl.print tl.delete(ids)
          exit
        end
        opts.on('-s','--search-visible REGEX' ,'Search active/visible tasks matching search regex' ) do |q|
          tl.print tl.search(q, :visible)
          exit
        end
        opts.on('-S','--search-all REGEX' ,'Search all the tasks' ) do |q|
          tl.print tl.search(q, :all)
          exit
        end
        opts.on('-v','--inverse-search-visible REGEX' ,"List visible tasks which don't match the input REGEX" ) do |q|
          tl.print tl.inverse_search(q, :visible)
          exit
        end
        opts.on('-V','--inverse-search-all REGEX' , "List *all* tasks which don't match the input REGEX" ) do |q|
          tl.print tl.inverse_search(q, :all)
          exit
        end
        opts.on('-e','--edit [ID]' ,'Open the task(s) file in vi' ) do |id|
          #TODO: should check the $EDITOR var and use it
          #TODO: need to refactor this
          if id
            task = tl.find([id]).first
            tmp_file_path = Tempfile.open(id) do |f|
              f.write task.raw_text
              f.path
            end
            edit_file(tmp_file_path)
            new_task_raw = File.readlines(tmp_file_path).first.to_s.chomp.strip
            if  new_task_raw.empty? || new_task_raw == task.raw_text.strip
              puts 'task not changed'.colorize(:red)
            else
              #TODO: need to refactor this
              new_task = Task.parse(task.raw_time.to_s + new_task_raw)
              task.raw_text = new_task_raw
              task.tags = new_task.tags
              tl.save
            end
            exit
          else
            edit_file Configuration.tasks_file_path
            exit
          end
        end
        opts.on('-t','--tag id1,id2,.. :tag1 :tag2 ..', Array, 'Tag task(s)') do |ids|
          tl.tag(ids, ARGV)
          exit
        end
        opts.on('-u','--untag id1,id2,.. :tag1 :tag2 ..', Array, 'Untag task(s)') do |ids|
          tl.untag(ids, ARGV)
          exit
        end
        opts.on('-p','--postpone id1,id2,..', Array, 'Postpone task(s) to tomorrow') do |ids|
          #TODO:cleanup this implementation
          today_tag = Configuration.val(:tag_transforms).find{|k,v| v == ':today'}.first
          tag = Configuration.val(:tag_transforms).find{|k,v| v == ':tomorrow'}.first
          tl.tag(ids, [tag])
          tl.untag(ids, [today_tag])
          exit
        end
        #opts.on('today','today','today') do
        #tag = Configuration.val(:tag_transforms).find{|k,v| v == ':today'}.first
        #tl.tag(ARGV[1], tag)
        #exit
        #end
        #opts.on('-tray','tray','tray') do
        #tl.tag(ARGV[1], ':tray')
        #exit
        #end
        opts.on('-f','--find id1,id2,..', Array, 'Find tasks with ids and show their details') do |ids|
          tl.print tl.find(ids)
          exit
        end
        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end
        opts.on( '-i', '--ids [PATTERN]', 'Used by tab completion' ) do |id|
          puts tl.ids(id)
          exit
        end
      end

      begin
        optparse.parse!
      rescue StandardError => e
        puts e.message
        exit
      end

      #if it reaches this line, it means no swtiches/options were passed
      if ARGV.empty?
        tl.list(Configuration.val(:list_size))
      else
        tl.append(ARGV.join(' '))
      end

    end
  end
end
