ConfigFile = File.expand_path('~/.taskr/config.rb')

require 'time'
require 'fileutils'
require 'tempfile'
require 'optparse'
require 'taskr/configuration'
Configuration.load

require 'taskr/version'
#extensions
require 'taskr/task'
require 'taskr/task_list'
require 'taskr/fixnum'
require 'taskr/string'
require 'taskr/time'
require 'taskr/scheduler'
require 'taskr/runner'
