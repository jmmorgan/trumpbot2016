class GraphmasterNode
  attr_accessor :parent
  attr_accessor :children

  def initialize
    @children ||= []
  end

  def find_or_append_child(node)
    result = @children.select{|n| n == node}.first
    unless result
      result = node
      node.parent = self
      @children << node
    end

    result
  end 

  def leaf?
    @children.empty?
  end

  def inspect
    self.to_s
  end

  def match?(input, that, topic)
    input.match(/#{Regexp.quote(self.path.map(&:to_regex).join(' ').strip)}/i) != nil
  end

  def path
    if (self.parent)
      self.parent.path << self
    else
      [self]
    end
  end

  def to_regex
    ""
  end
end
