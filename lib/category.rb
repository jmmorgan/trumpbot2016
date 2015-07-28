class Category
  attr_reader :pattern

  def initialize(options = {})
    @pattern = options[:pattern]
  end

  def match_pattern?(input)
    input == @pattern # For now.  We will dive into this soon
  end
end
