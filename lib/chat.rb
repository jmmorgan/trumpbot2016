class Chat
  attr_accessor :requests, :responses

  def initialize
    @requests = []
    @responses = []
  end

  def respond(input)
    sentences = normalize(input)
    path_matcher = PathMatcher.new
    normalized_responses = []

    sentences.each do |sentence|
      path_result = path_matcher.get_matching_path(GRAPHMASTER, sentence, '*', '*')
      template = path_result.path.last
      normalized_responses << template.apply(self, GRAPHMASTER)
    end

    response = normalized_responses.join(' ') # for now. We need to denormalize responses.

    save_exchange(input, response)
    response
  end

  def to_json
    {
      'requests' => @requests,
      'responses' => @responses
      }.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    result = Chat.new
    result.requests = hash['requests']
    result.responses = hash['responses']
    result
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

  def save_exchange(input, response)
    @requests << input
    @responses << response
  end
end