class Chat
  attr_accessor :requests, :responses

  def respond(input)
    sentences = normalize(input)
    path_matcher = PathMatcher.new
    normalized_responses = []

    sentences.each do |sentence|
      path_result = path_matcher.get_matching_path(GRAPHMASTER, sentence, '*', '*')
      template = path_result.path.last
      normalized_responses << template.apply(self, GRAPHMASTER)
    end

    normalized_responses.join('|') # for now
  end

  private

  def normalize(input)
    sentences = input.split(/[#{Regexp.quote(PROPERTIES_MAP_FILE['sentence-splitters'])}]/)
    sentences = sentences.map{|sentence| sentence.rjust(sentence.length + 1)}
    sentences.each do |sentence|
      NORMAL_SUBSTITUTION_MAP_FILE.each_pair do |key, value|
        sentence.gsub!(/(#{Regexp.quote(key)})/i, value)
      end
    end

    sentences.each_index do |i|
      # Normalize interword spaces and convert to caps
      sentences[i] = sentences[i].split.join(' ').upcase
    end
    
    sentences
  end
end
