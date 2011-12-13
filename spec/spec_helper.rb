file_path = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
taskr_base_path = File.expand_path File.join(File.dirname(file_path), '../lib')
$:.unshift taskr_base_path

require 'taskr'

def write_test_taskr_file
  FileUtils.mkdir_p Configuration.tasks_dir
  FileUtils.mkdir_p File.join(Configuration.tasks_dir, 'tmp')
  File.open(Configuration.tasks_file_path, 'w') do |f|
    f.puts <<EOS
20111111152254 cancel phone 7x :20111125 :weekend +++
20110913163000 install reddit :weekend +
20111115130124 google adwords setup :weekend ++
20111205172001 add wordpress blog
20111205172001 check fulcrum tasks :daily :hidden
EOS
  end
end

def load_test_config_file
  FileUtils.mkdir_p File.dirname(ConfigFile)
  File.open(File.expand_path(ConfigFile), 'w') do |f|
    f.puts <<EOS
tasks_dir "~/.taskr"
list_size 25
priority_regex /[+-]+/ #TODO: should probably be a priority_evaluator?
tag_regex  /(:[a-zA-Z0-9_:-]+)/

tag_transforms({
  (Time.now).strftime(":%Y%m%d") => ':today',
  (Time.now - 24 * 60 * 60).strftime(":%Y%m%d") => ':yesterday',
  (Time.now + 24 * 60 * 60 ).strftime(":%Y%m%d") => ':tomorrow'
})
EOS
  end
  Configuration.load
end


def create_task(text)
  Task.parse("20110303222222 #{text}")
end
