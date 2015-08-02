require 'graphmaster_node'

class Pound < Text

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    if (input_tokens.empty?)
      result = []
    elsif (!next_node)
      result = [input_tokens]
    elsif (next_node.wildcard?)
      result = [input_tokens.first]
    else
      result = []
      (0...input_tokens.length).each do |i|
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
    2
  end

  def wildcard?
    true
  end

end
