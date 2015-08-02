require 'graphmaster_node'

class PriorityWord < Text

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    result = nil
    if value.gsub(/\$/, '') == input_tokens.first
        result = [input_tokens.first]
    end

    result
  end

  def priority
    1
  end

  def word?
    true
  end

end
