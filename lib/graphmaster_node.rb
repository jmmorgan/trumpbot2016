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
    # Optimizing here.  Even though the path isn't technically immutable we will treat it thusly
    # for now because we *should* only reference this method after the node has been inserted 
    # into the Graphmaster (we'll see), and the path *should not* change once this 
    # node is appended to the Graphmaster.
    #
    # TODO: If this project builds momentum we might think about making this class essentially immutable.
    unless (@path)
      if (self.parent)
        @path = self.parent.path + [self]
      else
        @path = [self]
      end
    end
    
    @path
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

  def word?
    false
  end

  def size
    # For now
    1 + (@children.map(&:size).inject(&:+) || 0)
  end
end
