taskr_base_path = File.expand_path File.join(File.dirname(__FILE__), 'lib')
$:.unshift taskr_base_path

require 'taskr'

def run_cmd(cmd)
  puts "executing: #{cmd}"
  system(cmd)
end

desc 'Setup taskr'
task :setup do

  if File.directory?(File.expand_path('~/Dropbox'))
    run_cmd 'mkdir -p ~/Dropbox/taskr'
    run_cmd "ln -s ~/Dropbox/taskr #{Configuration.tasks_dir}"
  else
    run_cmd "mkdir -p #{Configuration.tasks_dir}"
    puts "symlink #{Configuration.tasks_dir} to a folder in your Dropbox folder to keep your tasks in sync"
  end

  run_cmd "touch  #{Configuration.tasks_file_path} #{Configuration.completed_tasks_file_path}"
  run_cmd "mkdir #{Configuration.tasks_dir}/tmp"
  puts "add this alias to your ~/.bashrc :\nalias t='#{taskr_base_path}/bin/taskr'"
end
