class Task
  #TODO: should always use date tags when marked as :today, :tomorrow
  #TODO: convert these to constants

  attr_accessor :raw, :raw_time, :raw_text, :tags

  def initialize(opts)
    self.raw = opts[:raw]
    self.raw_time = opts[:raw_time]
    self.raw_text = opts[:raw_text]
    self.tags = opts[:tags]
  end

  def self.parse(line)
    tags = line.scan(Configuration.val(:tag_regex)).flatten || []
    Task.new(:raw_time => line[0..13].to_i, :raw_text => line[15..-1], :raw => line, :tags => tags )
  end

  def to_s
    text_string = in_tray? ? self.text.colorize(:background => :white, :color => :black) : (self.transformed_tags.include?(':today') ? self.text.colorize(:color => :cyan) : self.text)
    "#{id.colorize(:yellow)}. #{text_string} #{ tag_s } (#{self.time.colorize(:magenta)} #{self.priority_text.colorize(:light_yellow)} #{priority})"
  end

  def tag_s
    pretty_tags = tags.map{|x| x.colorize(Configuration.tag_colors[x])}
    "[#{pretty_tags.join(' ')}]" unless pretty_tags.empty?
  end

  def serialize
    "#{self.raw_time} #{self.text} #{self.tags.join(' ')} #{self.priority_text}"
  end

  def priority
    priority = 0

    priority += self.tags.map{|x| Configuration.tag_priorities[x]}.compact.inject(0){|x, y| x + y} if tags && !tags.empty?

    priority += priority_text.count('+')
    priority -= priority_text.count('-')
  end

  def in_tray?
    self.tags.include?(':tray')
  end

  def visible?
    return false if tags.include?(':hidden')
    return true if Time.is_weekend? && tags.include?(':weekend')
    return false if tags.include?(':weekend') && !Time.is_weekend?

    return false if transformed_tags.include? ':tomorrow'
    return true
  end

  def recurring?
    tags.any?{|x| %w[:daily :weekly :monthly].include?(x)}
  end

  def priority_text
    raw_text.match(Configuration.val(:priority_regex)).to_s
  end

  def time
    Time.parse(raw_time.to_s).to_pretty
  end

  def id
    self.raw_time.to_s[8..-1].to_i.to_s_tid
  end

  def transformed_tags
    tags.map{|x| Configuration.val(:tag_transforms)[x] || x}
  end

  def text
    raw_text.gsub(Configuration.val(:tag_regex), '').gsub(Configuration.val(:priority_regex), '').strip
  end

end
