class Pattern
  attr_accessor :tokens

  def initialize(tokens)
    @tokens = tokens
  end

  def to_s
    @tokens.to_a.join(' ')
  end
end
