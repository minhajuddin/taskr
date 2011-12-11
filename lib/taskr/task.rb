class Task
  #TODO: should always use date tags when marked as :today, :tomorrow
  #TODO: convert these to constants
  PriorityRegex =  /^([+-]+)|([+-]+)$/
  TagRegex = /(:[a-zA-Z0-9_:-]+)/
  TagTransforms = {
    (Time.now).strftime(":%Y%m%d") => ':today',
    (Time.now - 24 * 60 * 60).strftime(":%Y%m%d") => ':yesterday',
    (Time.now + 24 * 60 * 60 ).strftime(":%Y%m%d") => ':tomorrow'
  }

  attr_accessor :raw, :raw_time, :raw_text, :tags

  def initialize(opts)
    self.raw = opts[:raw]
    self.raw_time = opts[:raw_time]
    self.raw_text = opts[:raw_text]
    self.tags = opts[:tags]
  end

  def self.parse(line)
    tags = line.scan(TagRegex).flatten || []
    Task.new(:raw_time => line[0..13].to_i, :raw_text => line[15..-1], :raw => line, :tags => tags )
  end

  def to_s
    text_string = in_tray? ? self.text.colorize(:background => :white, :color => :black) : (self.transformed_tags.include?(':today') ? self.text.colorize(:color => :cyan) : self.text)
    "#{id.colorize(:yellow)}. #{text_string} #{ tag_s } (#{self.time.colorize(:magenta)} #{self.priority_text.colorize(:light_yellow)})"
  end

  def tag_s
    pretty_tags = transformed_tags.map{|x| [':today', ':yesterday', ':tomorrow', ':weekend' ].include?(x) ? x.colorize(:light_yellow) : x.colorize(:yellow) }
    "[#{pretty_tags.join(' ')}]" unless pretty_tags.empty?
  end

  def serialize
    "#{self.raw_time} #{self.text} #{self.tags.join(' ')} #{self.priority_text}"
  end

  def priority
    -( in_tray? ? 100 : 0 + priority_text.count('*') + priority_text.count('+') - priority_text.count('-') + (self.visible? ? 2 : 0 ) + (self.tags.include?(:today) ? 3 : 0) )
  end

  def in_tray?
    self.tags.include?(':tray')
  end

  def visible?
    return true if Time.is_weekend? && tags.include?(':weekend')
    return false if tags.include?(':weekend') && !Time.is_weekend?

    return false if transformed_tags.include? ':tomorrow'
    return true
  end

  def priority_text
    raw_text.match(PriorityRegex).to_s
  end

  def time
    Time.parse(raw_time.to_s).to_pretty
  end

  def id
    self.raw_time.to_s[8..-1].to_i.to_s_tid
  end

  def transformed_tags
    tags.map{|x| TagTransforms[x] || x}
  end

  def text
    raw_text.gsub(TagRegex, '').gsub(PriorityRegex, '').strip
  end

end
