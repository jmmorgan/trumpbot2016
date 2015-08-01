class AimlRandom
  include TemplateContentNode

  def apply(chat, graphmaster)
    tokens.sample.apply(chat, graphmaster)
  end

end
