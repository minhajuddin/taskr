class Fixnum

  CHARS = ('a'..'z').to_a
  def to_s_tid
    i = self
    return '0' if i == 0
    length = CHARS.length
    s = ''
    while i > 0
      s << CHARS[i.modulo(length)]
      i /= length
    end
    s.reverse
  end

end
