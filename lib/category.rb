class Category
  attr_accessor :pattern, :that

  def initialize(options = {})
    @pattern = options[:pattern]
  end

  def match_pattern?(input)
    pattern.match?(input)
  end
end
