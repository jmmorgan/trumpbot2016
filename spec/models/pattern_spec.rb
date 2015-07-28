require 'spec_helper'
require 'nokogiri'
require 'pattern'
require 'parsers/pattern_xml_parser'

describe Pattern do

  describe '#match?' do

    describe 'Basic text' do
      let(:pattern) {Parsers::PatternXmlParser.new.parse(Nokogiri::XML("<pattern>HOW DO YOU WORK</pattern").root) }

      it 'returns true when the input matches the pattern' do
        expect(pattern.match?('HOW DO YOU WORK SO WELL')).to be true
      end

    end

  end

end
