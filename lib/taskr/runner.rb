module Taskr
  class Runner
    def self.execute

      tl = TaskList.new

      optparse = OptionParser.new do |opts|

        opts.on('-l', '--list [NUM]', 'List all the tasks') do |num|
          num = num ? num.to_i : 5
          tl.list(num)
          exit
        end
        opts.on('-L','--list-all' ,'List all the tasks' ) do
          tl.list(:all)
          exit
        end
        opts.on('-d','--delete id1,id2,..', Array,'Delete tasks(s)' ) do |ids|
          #tl.delete(ARGV[1])
          exit
        end
        opts.on('-s','--search' ,'Search all the tasks' ) do
          tl.search(ARGV[1])
          exit
        end
        opts.on('-e','--edit' ,'Open the tasks file in vi' ) do
          system("vi #{Filepath}")
          exit
        end
        opts.on('-t','--tag' ,'Tag task(s)' ) do
          tl.tag(ARGV[1], ARGV[2])
          exit
        end
        opts.on('-u','--untag' ,'Untag task(s)' ) do
          tl.untag(ARGV[1], ARGV[2])
          exit
        end
        #opts.on('today','today','today') do
        #tag = Task::TagTransforms.find{|k,v| v == ':today'}.first
        #tl.tag(ARGV[1], tag)
        #exit
        #end
        opts.on('-p','--postpone','Postpone the task to tomorrow') do
          today_tag = Task::TagTransforms.find{|k,v| v == ':today'}.first
          tag = Task::TagTransforms.find{|k,v| v == ':tomorrow'}.first
          tl.tag(ARGV[1], tag)
          tl.untag(ARGV[1], today_tag)
          exit
        end
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

      optparse.parse!

    end
  end
end
