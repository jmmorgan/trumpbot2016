class Pattern
  attr_accessor :tokens

  def match?(input)
    input =~ /#{Regexp.quote(@tokens.map(&:to_s).join)}/i
  end

end
