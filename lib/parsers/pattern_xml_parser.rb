require 'parsers/bot_parser'
require 'parsers/eval_parser'
require 'parsers/set_parser'
require 'parsers/star_parser'
require 'text'

module Parsers
  class PatternXmlParser

    def parse(pattern_element)
      pattern = Pattern.new
      pattern.tokens = parse_tokens(pattern_element.children)
      pattern
    end

    private

    def parse_tokens(nodes)
      tokens = []
      nodes.each do |node|
        if (node.text?)
          tokens += node.content.split.collect{|word| Text.new(word)}
        else
          name = node.name
          parser_class = PARSER_MAP[name]
          raise "Unexpected element '#{name}' found in pattern: #{nodes.to_s}" if !parser_class
          tokens << parser_class.new.parse(node)
        end
      end

      tokens
    end

    PARSER_MAP = {
      'bot' => Parsers::BotParser,
      'eval' => Parsers::EvalParser,
      'set' => Parsers::SetParser,
      'star' => Parsers::StarParser
    }
  end
end
