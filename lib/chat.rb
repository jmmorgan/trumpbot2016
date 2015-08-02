class Chat
  attr_accessor :requests, :responses, :predicates

  def initialize
    @requests = []
    @responses = []
    @predicates = {}
  end

  def respond(input)
    sentences = normalize(input)
    path_matcher = PathMatcher.new
    normalized_responses = []

    sentences.each do |sentence|
      path_result = path_matcher.get_matching_path(GRAPHMASTER, sentence, '*', '*')
      normalized_responses << path_result.apply_template(predicates)
    end

    response = denormalize(normalized_responses).join(' ') 

    save_exchange(input, response)
    response
  end

  def clear
    @requests.clear
    @responses.clear
    @predicates.clear
  end

  def to_json
    {
      'requests' => @requests,
      'responses' => @responses,
      'predicates' => @predicates
      }.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    result = Chat.new
    result.requests = hash['requests'] || []
    result.responses = hash['responses'] || []
    result.predicates = hash['predicates'] || {}
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

  def denormalize(normalized_responses)
    result = normalized_responses
    # TODO: Apply substitutions found in substituition map file

    # Clean out leading spaces before punctuation (may need to to tweak this as we go along)
    result = result.collect{|sentence| sentence.gsub(/\s+([\.\?!,])/, '\1')}

    result
  end

  def save_exchange(input, response)
    @requests << input
    @responses << response
  end
end
