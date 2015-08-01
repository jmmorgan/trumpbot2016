class Srai 
  include TemplateContentNode

  def apply(chat, graphmaster)
    result = nil
    if (text_only?)
      category = graphmaster.find_category(tokens.join(' '))
      if (category)
        result = category.template.apply(chat, graphmaster)
      end
    else
      super
    end

    result
  end

  private 

  def text_only?
    tokens.select{|token| token.is_a?(String)}.count == tokens.count
  end

end
