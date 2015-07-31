class PathMatcher

  def get_matching_path(graphmaster, input, that, topic)
    result = nil
    visited_nodes = Set.new
    current_node = graphmaster

    while (current_node)
      path_match_result = get_path_match_result(current_node, input, that, topic)
      # Pluck first available child
      unvisited_children = current_node.children.reject{|child| visited_nodes.include?(child)}
      if (unvisited_children.empty? || !path_match_result)
        visited_nodes.add(current_node)
        if (current_node.leaf? && path_match_result)
          result = path_match_result
          break
        end
        current_node = current_node.parent
      else
        current_node = unvisited_children.first
      end
    end

    result
  end

  private

  def get_path_match_result(node, input, that, topic)
    match = true
    path = node.path
    path_mappings = {}
    input_tokens = input.split

    path.slice(0, path.count).each_index do |i|
      node = path[i]
      next_node = path[i+1]
      matching_tokens = node.matching_tokens(input_tokens, next_node, that, topic)
      unless (matching_tokens)
        match = false
        break
      else
        input_tokens.shift(matching_tokens.length)
      end
    end

    match ? PathMatchResult.new(path, path_mappings) : nil
  end
  
end
