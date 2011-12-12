class Configuration
  attr_reader :attributes

  def initialize(config_path)

    @attributes = {
      :list_size => 20
    }

    @attributes.keys.each do |attr|
      self.instance_eval("def #{attr}(val); @attributes[:#{attr}] = val; end")
    end

    instance_eval File.read(config_path) if File.exists?(config_path)
  end

  def self.load(config_path = File.expand_path("~/.taskr/config"))
    @@config = Configuration.new(config_path)
  end

  def self.config
    @@config
  end

end
