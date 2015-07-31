class Bot

  def respond(input)
    sentences = normalize(input)
    path_matcher = PathMatcher.new
    path_results = []

    sentences.each do |sentence|
      path_results << path_matcher.get_matching_path(GRAPHMASTER, sentence, '*', '*')
    end

    "The matching paths are: #{path_results.map(&:path).join('|')}"
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
    puts sentences.inspect
    sentences
  end
end
