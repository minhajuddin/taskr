def run_cmd(cmd)
  puts "executing: #{cmd}"
  system(cmd)
end

desc 'Setup taskr'
task :setup do

  if File.directory?(File.expand_path('~/Dropbox'))
    run_cmd 'mkdir -p ~/Dropbox/taskr'
    run_cmd 'ln -s ~/Dropbox/taskr ~/.taskr'
  else
    run_cmd 'mkdir -p ~/.taskr'
    puts 'symlink ~/.taskr to a folder in your Dropbox folder to keep your tasks in sync'
  end

  run_cmd 'touch ~/.taskr/tasks.taskr ~/.taskr/tasks.taskr.done'
  run_cmd 'mkdir ~/.taskr/tmp'
  puts "add this alias to your ~/.bashrc : alias t='<path-to-script>/bin/taskr'"
end
