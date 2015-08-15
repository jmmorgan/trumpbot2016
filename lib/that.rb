class That < GraphmasterNode
  include TemplateContentNode
  attr_accessor :expression

  def initialize(expression='*')
    @expression = expression
    super()
  end

  def ==(other_object)
    return other_object.is_a?(That) && other_object.expression == @expression
  end

  def priority
    self.expression == '*' ? 8.1 : 8.0 # Make sure '*' is last evaluated
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    input_tokens.empty? && (self.expression == '*' || that == self.expression) ? [] : nil
  end

  def to_s
    "<that>#{self.expression}"
  end
end
