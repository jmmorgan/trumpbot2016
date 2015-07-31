require 'parsers/bot_xml_parser'
require 'parsers/eval_xml_parser'
require 'parsers/set_xml_parser'
require 'parsers/star_xml_parser'
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
          tokens += node.content.split.collect{|token| to_text_node(token)}
        else
          name = node.name
          parser_class = PARSER_MAP[name]
          raise "Unexpected element '#{name}' found in pattern: #{nodes.to_s}" if !parser_class
          tokens << parser_class.new.parse(node)
        end
      end

      tokens
    end

    def to_text_node(token)
      case token
      when /^\$/
        PriorityWord.new(token)
      when '#'
        Pound.new(token)
      when '_'
        Underscore.new(token)
      when '^'
        Caret.new(token)
      when '*'
        Asterisk.new(token)
      else
        Word.new(token)
      end
    end


    PARSER_MAP = {
      'bot' => Parsers::BotXmlParser,
      'eval' => Parsers::EvalXmlParser,
      'set' => Parsers::SetXmlParser,
      'star' => Parsers::StarXmlParser
    }
  end
end
