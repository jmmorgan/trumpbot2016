module TemplateContentNode
  attr_accessor :tokens, :attributes, :element_name

  # Applies this template to the given PathMatchResult, Graphmaster predicates and returns
  # a normalized response.
  #
  # Classes including this module should override this method to return a normalized response 
  # fragment, or nil when appropriate.
  def apply(path_match_result, graphmaster, predicates)
    #puts "self.class = #{self.class} #{tokens.to_s}" # For debugging for now
    result = tokens.map{|token| token.is_a?(String) ? token : token.apply(path_match_result, graphmaster, predicates)}.join(' ')
  end

  def to_s
    raw_xml
  end

  def raw_xml
    #TODO: Move this implementation to an XML builder class
    result = "<#{element_name}"
    if (!attributes.empty?)
      attributes.keys.sort.each do |key|
        result << " #{key}=\"#{attributes[key]}\""
      end
    end
    result << ">"

    tokens.each do |token|
      if (token.is_a?(TemplateContentNode))
        result << token.raw_xml
      else
        result << "#{token.to_s} " 
      end
    end

    result << "</#{element_name}>"
  end

  def deep_clone
    result = clone
    result.element_name = element_name 
    result.attributes = attributes ? attributes.clone() : {}
    result.tokens = tokens.to_a.collect{|token| token.respond_to?(:deep_clone) ? token.deep_clone : token.clone}
    result
  end
end
