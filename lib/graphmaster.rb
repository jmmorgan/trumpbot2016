class Graphmaster < GraphmasterNode

  def initialize
    @category_to_pattern_map = {}
    super()
  end

  def add_category(category)
    tokens = category.pattern.tokens
    @category_to_pattern_map[tokens.join(' ')] = category
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

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    []
  end

  def find_category(pattern)
    @category_to_pattern_map[pattern]
  end

end
