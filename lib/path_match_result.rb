class PathMatchResult
  attr_accessor :path, :path_mappings

  def initialize(path, path_mappings)
    @path = path
    @path_mappings = path_mappings
  end

end
