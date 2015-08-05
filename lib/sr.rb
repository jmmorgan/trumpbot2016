class Sr < Srai

  def initialize
    star = Star.new
    star.element_name = 'star'
    star.attributes = {}
    star.tokens = []
    @tokens = [star]
  end

  def tokens=(tokens)
    # No-op
  end
end
