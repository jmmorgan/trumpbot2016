class Chat
  attr_accessor :requests, :responses, :predicates, :original_case_format_map

  def initialize
    @requests = []
    @responses = []
    @predicates = {}
    @original_case_format_map = {}
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

  def transcript
    result = ''
    @requests.each_index do |i|
      result << "You: #{@requests[i]}" << "\n"
      if (response =  responses[i])
        result << "TrumBot: #{response}" << "\n"
      end
    end

    result
  end

  def to_json
    {
      'requests' => @requests,
      'responses' => @responses,
      'predicates' => @predicates,
      'original_case_format_map' => @original_case_format_map
      }.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    result = Chat.new
    result.requests = hash['requests'] || []
    result.responses = hash['responses'] || []
    result.predicates = hash['predicates'] || {}
    result.original_case_format_map = hash['original_case_format_map'] || {}
    result
  end

  private

  # TODO: This current implementation is somewhat brittle in that the order that entries in the
  # map file are applied affects the 'normalized' result. Should revisit if this project develops legs.
  def normalize(input)
    sentences = input.split(/[#{Regexp.quote(PROPERTIES_MAP_FILE['sentence-splitters'])}](\s+|$)/).reject(&:blank?)
    sentences = sentences.map{|sentence| " #{sentence} "} # Pad with spaces for normal substitutions
    sentences.each do |sentence|
      NORMAL_SUBSTITUTION_MAP_FILE.each_pair do |key, value|
        sentence.gsub!(/(#{Regexp.quote(key)})/i, value)
      end
    end
    sentences.map(&:strip!)

    sentences.each_index do |i|
      # Normalize interword spaces and convert to caps
      original_tokens = sentences[i].split
      upcase_tokens = original_tokens.map(&:upcase)
      original_tokens.each_index do |j|
        @original_case_format_map[upcase_tokens[j]] = original_tokens[j]
      end
      sentences[i] = upcase_tokens.join(' ')
    end
    
    sentences
  end

  def denormalize(normalized_responses)
    result = normalized_responses
    result.each do |sentence|
      # First substitute an all CAPS words
      sentence.scan(/\b[A-Z0-9]+\b/).each do |word|
        sentence.gsub!(/\b#{word}\b/, @original_case_format_map[word] || word)
      end

      #DENORMAL_SUBSTITUTION_MAP_FILE.each_pair do |key, value|
        #sentence.gsub!(/(#{Regexp.quote(key)})/, value)
      #end
    end

    # Clean out leading spaces before punctuation (may need to to tweak this as we go along)
    result = result.collect{|sentence| sentence.gsub(/\s+([\.\?!,\:;])/, '\1').strip}


    result
  end

  def save_exchange(input, response)
    @requests << input
    @responses << response
  end
end
