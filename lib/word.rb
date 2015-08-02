require 'graphmaster_node'

class Word < Text

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    result = nil
    if value == input_tokens.first
        result = [input_tokens.first]
    end

    result
  end

  def priority
    4
  end

  def word?
    true
  end

end
