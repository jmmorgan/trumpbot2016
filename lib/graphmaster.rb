class Graphmaster < GraphmasterNode

  def add_category(category)
    tokens = category.pattern.tokens
    current_node = self
    current_token = tokens.shift

    while (current_token)
      current_node = current_node.find_or_append_child(current_token)
      current_token = tokens.shift
    end

    current_node.find_or_append_child(category.that)

    self
  end
end
