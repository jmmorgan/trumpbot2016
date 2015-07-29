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

  def to_s
    "#{self.class}, children: #{children}"
  end

end
