file_path = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
taskr_base_path = File.expand_path File.join(File.dirname(file_path), '../lib')
$:.unshift taskr_base_path

Filepath = File.expand_path("~/.taskr/tasks.taskr")

require 'taskr'

def write_test_taskr_file
      FileUtils.mkdir_p(File.dirname(Filepath))
      FileUtils.mkdir_p(File.join(File.dirname(Filepath), 'tmp'))
      File.open(Filepath, 'w') do |f|
        f.puts <<EOS
20111111152254 cancel phone 7x :20111125 :weekend +++
20110913163000 install reddit :weekend +
20111115130124 google adwords setup :weekend ++
20111205172001 add wordpress blog
20111205172001 check fulcrum tasks :daily :hidden
EOS
      end
end

def create_task(text)
  Task.parse("20110303222222 #{text}")
end
