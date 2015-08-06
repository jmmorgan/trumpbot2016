class PathMatcher

  def get_matching_path(graphmaster, input, chat_session_id = nil, that = '*', topic = '*')
    result = get_cached_result(input, chat_session_id)
    return result if result
    visited_nodes = init_visited_nodes(graphmaster, input)
    current_node = graphmaster

    while (current_node)
      path_match_result = get_path_match_result(graphmaster, current_node, input, that, topic)
      # Pluck first available child
      unvisited_children = current_node.children.reject{|child| 
        visited_nodes.include?(child) || (child.chat_session_id && child.chat_session_id != chat_session_id)
      }
      if (unvisited_children.empty? || !path_match_result)
        visited_nodes.add(current_node)
        if (current_node.is_a?(Template) && path_match_result)
          result = path_match_result
          break
        end
        current_node = current_node.parent
      else
        current_node = unvisited_children.first
      end
    end

    put_cached_result(input, chat_session_id, result)
  end

  private

  def get_path_match_result(graphmaster, node, input, that, topic)
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
        path_mappings[node] = matching_tokens
        input_tokens.shift(matching_tokens.length)
      end
    end
    puts path if match
    match ? PathMatchResult.new(path, path_mappings, graphmaster) : nil
  end

  # Optimization to avoid processing nodes with words that are not in the input
  def init_visited_nodes(graphmaster, input)
    result = Set.new
    graphmaster.word_nodes.each do |node|
      if input !~ /#{node.word_value}/ 
        result << node
      end
    end

    result
  end

  def get_cached_result(input, chat_session_id)
    (@@cached_results ||= {})[[input, chat_session_id]]
  end

  def put_cached_result(input, chat_session_id, pattern_match_result)
    (@@cached_results ||= {})[[input, chat_session_id]] = pattern_match_result
  end
end
