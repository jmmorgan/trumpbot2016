class Pattern
  attr_accessor :tokens

  def to_s
    @tokens.to_a.join(' ')
  end
end
