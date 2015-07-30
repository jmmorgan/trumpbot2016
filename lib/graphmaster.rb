class Graphmaster < GraphmasterNode

  def add_category(category)
    tokens = category.pattern.tokens
    current_node = self
    current_token = tokens.shift

    while (current_token)
      current_node = current_node.find_or_append_child(current_token)
      current_token = tokens.shift
    end

    current_node = current_node.find_or_append_child(category.that)
    current_node.find_or_append_child(category.topic)

    self
  end

  def get_matching_paths(input, that = '*', topic = '*')
    result = nil
    visited_nodes = Set.new

    current_node = self
    
    while (current_node)
      unvisited_children = current_node.children.reject{|child| visited_nodes.include?(child)}
      if (unvisited_children.empty?)
        visited_nodes.add(current_node)
        if (current_node.leaf? && current_node.match?(input, that, topic))
          result = current_node.path
          break
        end
        current_node = current_node.parent
      else
        current_node = unvisited_children.first
      end
    end

    result
  end
end
