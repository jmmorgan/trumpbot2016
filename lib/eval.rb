class Eval < GraphmasterNode
  include TemplateContentNode

  def priority
    3
  end

  def apply(path_match_result, graphmaster, predicates)
    #TODO: implement
puts "@apply not yet implemented for #{self.class}"
nil
  end
end
