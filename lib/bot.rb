class Bot

  def respond(input)
    normalize(input)

    "I'm seriously impressed"
  end

  private

  def normalize(input)
    sentences = input.split(/[#{Regexp.quote(PROPERTIES_MAP_FILE['sentence-splitters'])}]/)
    sentences = sentences.map(&:strip)
  end
end
