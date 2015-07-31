require 'graphmaster_node'

class Underscore < Word

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    if (input_tokens.empty?)
      result = nil
    elsif (!next_node)
      result = [input_tokens]
    elsif (next_node.wildcard?)
      result = [input_tokens.first]
    else
      result = [input_tokens.first]
      (1...input_tokens.length).each do |i|
        if (!next_node.matching_tokens(input_tokens.slice(i, input_tokens.length), nil))
          result << input_tokens[i]
        else
          break
        end
      end
    end

    result
  end

  def priority
    3
  end

  def wildcard?
    true
  end

end
