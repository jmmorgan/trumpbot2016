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
      @children.sort!{|a,b| a.priority <=> b.priority}
    end

    result
  end 

  def inspect
    self.to_s
  end

  def path
    if (self.parent)
      self.parent.path << self
    else
      [self]
    end
  end

  def priority
    0
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    nil
  end

  def wildcard?
    false
  end
end
