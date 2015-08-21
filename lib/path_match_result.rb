class PathMatchResult
  attr_accessor :path, :path_mappings

  def initialize(path, path_mappings, graphmaster)
    @path = path
    @path_mappings = path_mappings
    @graphmaster = graphmaster
  end

  # Returns Array of tuples. Each tuple represents a node with dynamic value (wildcard, set, etc.)
  # in the order it is found in the @path. Each tuple is an Array of two value:
  #   [0]: The node
  #   [2]: The array of pattern tokens mapped to the given wilcard node
  def star_mappings
    @path_mappings.inject([]) do |memo, (key, value)|
      memo << [key, value] if (key.dynamic?)
      memo
    end
  end

  def pattern
    @graphmaster.category_for_template(@path.last).pattern
  end

  def source_file
    @graphmaster.category_for_template(@path.last).source_file
  end

  def apply_template(predicates, category_stack)
    #puts "APPLYING TEMPLATE FOR PATH #{@path}"
    category = @graphmaster.category_for_template(@path.last)
    if (!category_stack.include?(category))
      category_stack.push(category)
      @path.last.apply(self.star_mappings, @graphmaster, predicates, category_stack)
    else
      # For now just return a default response
      "I'm having trouble understanding you."
    end
  end

end
