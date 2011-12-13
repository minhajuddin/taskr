class Configuration
  attr_reader :attributes

  def initialize(config_path)

    @attributes = {
      :list_size => 20,
      :tasks_dir => '~/.taskr',
      :priority_regex  => /[+-]+/,
      :tag_regex  =>  /(:[a-zA-Z0-9_:-]+)/,
      :editor => 'vi',

      :tag_transforms => {
        (Time.now).strftime(":%Y%m%d") => ':today',
        (Time.now - 24 * 60 * 60).strftime(":%Y%m%d") => ':yesterday',
        (Time.now + 24 * 60 * 60 ).strftime(":%Y%m%d") => ':tomorrow'
      }

    }

    @attributes.keys.each do |attr|
      self.instance_eval("def #{attr}(val); @attributes[:#{attr}] = val; end")
    end

    instance_eval File.read(config_path) if File.exists?(config_path)
  end

  def self.load(config_path = File.expand_path(ConfigFile))
    @@config = Configuration.new(config_path)
  end

  def self.config
    @@config
  end

  def self.val(attr)
    config.attributes[attr]
  end

  def self.tasks_dir
    File.expand_path val(:tasks_dir)
  end

  def self.tasks_file_path
    File.join(tasks_dir, 'tasks.taskr')
  end

  def self.completed_tasks_file_path
    File.join(tasks_dir, 'tasks.taskr.done')
  end

  def self.editor
    val(:editor)
  end

end
