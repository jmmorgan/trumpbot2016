class PathMatchResult
  attr_accessor :path, :path_mappings

  def initialize(path, path_mappings, graphmaster)
    @path = path
    @path_mappings = path_mappings
    @graphmaster = graphmaster
  end

  # Returns Array of tuples. Each tuple represents a wilcard node
  # in the order it is found in the @path. Each tuple is an Array of two value:
  #   [0]: The wildcard node
  #   [2]: The array of pattern tokens mapped to the given wilcard node
  def star_mappings
    @path_mappings.inject([]) do |memo, (key, value)|
      memo << [key, value] if (key.wildcard?)
      memo
    end
  end

  def apply_template
    @path.last.apply(self, @graphmaster)
  end

end
