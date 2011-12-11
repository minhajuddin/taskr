file_path = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
taskr_base_path = File.expand_path File.join(File.dirname(file_path), '../lib')
$:.unshift taskr_base_path

require 'taskr'
