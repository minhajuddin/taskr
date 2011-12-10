module Taskr
  class Runner
    def self.execute

      tl = TaskList.new

      optparse = OptionParser.new do |opts|

        opts.banner = "Usage: taskr [options]"

        opts.on('-a', '--add task description', :NONE, 'Add task to the list') do
          tl.append(ARGV.join(' '))
          exit
        end
        opts.on('-l', '--list [NUM]', Integer, 'List all the tasks') do |num|
          tl.list(num||5)
          exit
        end
        opts.on('-L','--list-all' ,'List all the tasks' ) do
          tl.list(:all)
          exit
        end
        opts.on('-d','--delete id1,id2,..', Array,'Delete tasks(s)' ) do |ids|
          tl.delete(ids)
          exit
        end
        opts.on('-s','--search REGEX' ,'Search all the tasks' ) do |q|
          tl.search(q)
          exit
        end
        opts.on('-e','--edit' ,'Open the tasks file in vi' ) do
          #TODO: should check the $EDITOR var and use it
          system("vi #{Filepath}")
          exit
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
          today_tag = Task::TagTransforms.find{|k,v| v == ':today'}.first
          tag = Task::TagTransforms.find{|k,v| v == ':tomorrow'}.first
          tl.tag(ids, [tag])
          tl.untag(ids, [today_tag])
          exit
        end
        #opts.on('today','today','today') do
        #tag = Task::TagTransforms.find{|k,v| v == ':today'}.first
        #tl.tag(ARGV[1], tag)
        #exit
        #end
        #opts.on('-tray','tray','tray') do
        #tl.tag(ARGV[1], ':tray')
        #exit
        #end
        #opts.on('show','show','show') do
        #tl.show(ARGV[1])
        #exit
        #end
        opts.on('-x','--xmobar','Text to be shown in xmobar') do
          tl.xmobar
          exit
        end
        opts.on( '-v', '--version', 'Display version of taskr' ) do
          puts Taskr::VERSION
          exit
        end
        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end
      end

      begin
      optparse.parse!
      rescue OptionParser::MissingArgument => e
        puts e.message
        puts optparse.inspect
      end

    end
  end
end
