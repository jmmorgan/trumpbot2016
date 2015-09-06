# Tree where root node is a category matched to an input path and child nodes represent categories matched through succeeding <srai> references. 
class CategoryTree
  attr_accessor :root, :current_node

  def append(category)
    node = CategoryTreeNode.new(category, @current_node)
    if @current_node
      @current_node.children << node
    end
    @root ||= node
    @current_node = node
  end

  # Sort of hack-ish.
  # For a first pass at this we'll have branch return a clone
  # of the tree.  The underlyind tree-structure will be shared 
  # but @current_node can be assigned to different nodes in different
  # branches.
  # As a future exercise we can try making this entire class an immutable.
  def branch()
    self.clone
  end

  def current_path
    @current_node ? @current_node.path : []
  end

  def paths
    result = []
    if (@root)
      processed_nodes = Set.new

      while (!processed_nodes.include?(@root))
        current_node = @root
        current_path = []
        while (true)
          current_path << current_node
          if (current_node.children.empty?)
            processed_nodes << current_node
            result << current_path
            break
          elsif (current_node = current_node.children.reject{|node| processed_nodes.include?(node)}.first)
            # continue
          else
            processed_nodes << current_path.last
            break
          end
        end
      end
    end

    result
  end

  def to_s
    result = StringIO.new

    paths.each do |path|
      path.each_index do |i|
        result << ("  " * i)
        result << "[#{i}] #{path[i].category.pattern.to_s}\n"
      end
    end

    result.string
  end

  class CategoryTreeNode
    attr_accessor :category, :children, :parent, :path

    def initialize(category, parent)
      @category = category
      @children = []
      @parent = parent
      @path = @parent ? @parent.path + [self] : [self]
      circular_pattern_check
    end

    def circular_pattern_check
      # Law of Demeter smell?
      if (@path.map(&:category).map(&:pattern).map(&:to_s).uniq.count < @path.count)
        raise "Circular reference detected in #{@path.map(&:category).map(&:pattern).map(&:to_s)}"
      end
    end

  end

end
