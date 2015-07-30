require 'graphmaster_node'

class Text < GraphmasterNode
  attr_accessor :value

  def initialize(value = '')
    @value = value
    super()
  end

  def ==(other)
    return other.is_a?(Text) && other.value == @value
  end

  def to_s
    @value
  end

  def to_regex
    value.gsub(/\*/, '[A-Z0-9 ]+').gsub(/\$/, '').gsub(/\#/, '[A-Z0-9 ]*')
  end

  def priority
    case @value.first
    when '$'
      1
    when '#'
      2
    when '_'
      3
    when '^'
      6
    when '*'
      7
    else
      3
    end
  end
      
end
