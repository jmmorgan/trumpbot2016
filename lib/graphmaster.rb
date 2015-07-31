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
    current_node = current_node.find_or_append_child(category.topic)
    current_node = current_node.find_or_append_child(category.template)

    self
  end

  def get_matching_path(input, that = '*', topic = '*')
    # TODO: Remove this call-through
    PathMatcher.new.get_matching_path(self, input, that, topic).path
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    []
  end

end
