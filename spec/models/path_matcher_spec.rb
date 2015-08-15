require 'spec_helper'
require 'rails_helper'

describe PathMatcher do
  let(:path_matcher) { PathMatcher.new }
  let(:graphmaster) { Graphmaster.new }

  describe '#get_matching_path' do
    let(:chat_session_id) { 1 }
    let(:that) { '*' }
    let(:path_match_result) { path_matcher.get_matching_path(graphmaster, input_pattern, chat_session_id, that) }
    let(:path) { path_match_result.path }

    before do
      [
        ["*", 'udc.aiml'], ["HOW DO YOU WORK", 'personality.aiml'], ['MY FAVORITE COLOR IS *', 'client_profile.aiml'],
        ["* IS <set>color</set>", 'train.aiml'], ["* <set>was</set> *", 'train.aiml'], 
        ['$EMAIL * TO SAY *', 'reductions2.aiml'], ["# DO YOU WATCH PORN #", 'inappropriate.aiml'],
        ['WHAT IS THE MONETARY _ ENGLAND', 'default.aiml'], ["* IS THE *", 'train.aiml'],
        ['WHAT DO YOU # <set>rival</set> #', 'rivals.aiml'], ["IS <set>bird</set> A BIRD", 'knowledge.aiml'],
        ["IS * A BIRD", 'knowledge.aiml'], ["<set>name<set>", 'train.aiml', 'WHAT IS YOUR NAME']
      ].each do |tuple|

        template = Template.new
        template.tokens = ["I'm confused"] # TODO: Refactor Template so all ivars can be set in initializer
        graphmaster.add_category(Category.new(parse_input_pattern(tuple[0]), That.new(tuple[2] || '*'), Topic.new('*'), template, tuple[1]))
      end
    end

    context 'pattern contains text only' do
      let(:input_pattern) { 'HOW DO YOU WORK' }

      it 'returns the matching path' do
        expect(path.count).to eq 8
        expect(path.slice(1,4).join(' ')).to eq 'HOW DO YOU WORK'
      end

      it 'returns the matching pattern' do
        expect(path_match_result.pattern.to_s).to eq 'HOW DO YOU WORK'
      end

      it 'returns the file where the matching pattern was found' do
        expect(path_match_result.source_file).to eq 'personality.aiml'
      end
    end

    context 'pattern contains one trailing *' do
      let(:input_pattern) { 'MY FAVORITE COLOR IS PLAID' }

      it 'returns the matching path' do
        expect(path.count).to eq 9
        expect(path.slice(1,5).join(' ')).to eq 'MY FAVORITE COLOR IS *'
      end

      it 'returns the matching pattern' do
        expect(path_match_result.pattern.to_s).to eq 'MY FAVORITE COLOR IS *'
      end

      it 'returns the file where the matching pattern was found' do
        expect(path_match_result.source_file).to eq 'client_profile.aiml'
      end
    end

    context 'pattern contains one leading *' do
      let(:input_pattern) { 'TABLE SALT IS WHITE' }

      it 'returns the matching path' do
        expect(path.count).to eq 7
        expect(path.slice(1,3).join(' ')).to eq '* IS <set>color</set>'
      end

      it 'returns the matching pattern' do
        expect(path_match_result.pattern.to_s).to eq '* IS <set>color</set>'
      end

      it 'returns the file where the matching pattern was found' do
        expect(path_match_result.source_file).to eq 'train.aiml'
      end
    end

    context 'pattern contains leading and trailing *' do
      let(:input_pattern) { 'TRIXIEBEAN GAVE ME A SCARE' }

      it 'returns the matching path' do
        expect(path.count).to eq 7
        expect(path.slice(1,3).join(' ')).to eq '* <set>was</set> *'
      end

      it 'returns the matching pattern' do
        expect(path_match_result.pattern.to_s).to eq '* <set>was</set> *'
      end

      it 'returns the file where the matching pattern was found' do
        expect(path_match_result.source_file).to eq 'train.aiml'
      end
    end

    context 'pattern contains $' do
      let(:input_pattern) { 'EMAIL JON TO SAY I AM GOING' }

      it 'returns the matching path' do
        expect(path.count).to eq 9
        expect(path.slice(1,5).join(' ')).to eq '$EMAIL * TO SAY *'
      end

      it 'returns the matching pattern' do
        expect(path_match_result.pattern.to_s).to eq '$EMAIL * TO SAY *'
      end

      it 'returns the file where the matching pattern was found' do
        expect(path_match_result.source_file).to eq 'reductions2.aiml'
      end
    end

    context 'pattern contains #' do
      let(:input_pattern) { 'HOW DO YOU WORK' }

      context 'words are matched' do
        let(:input_pattern) { 'IN WHICH ROOMS DO YOU WATCH PORN' }

        it 'returns the matching path' do
          expect(path.count).to eq 10
          expect(path.slice(1,6).join(' ')).to eq '# DO YOU WATCH PORN #'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq '# DO YOU WATCH PORN #'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'inappropriate.aiml'
        end
      end

      context 'words are matched' do
        let(:input_pattern) { 'DO YOU WATCH PORN' }

        it 'returns the matching path when zero words match' do
          expect(path.count).to eq 10
          expect(path.slice(1,6).join(' ')).to eq '# DO YOU WATCH PORN #'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq '# DO YOU WATCH PORN #'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'inappropriate.aiml'
        end
      end
    end

    context 'pattern contains _' do
      context 'words are matched' do
        let(:input_pattern) { 'WHAT IS THE MONETARY UNIT IN ENGLAND' }

        it 'returns the matching path' do
          expect(path.count).to eq 10
          expect(path.slice(1,6).join(' ')).to eq 'WHAT IS THE MONETARY _ ENGLAND'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq 'WHAT IS THE MONETARY _ ENGLAND'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'default.aiml'
        end
      end


      context 'zero words match' do
        let(:input_pattern) { 'WHAT IS THE MONETARY ENGLAND' }

        it 'returns the default when zero words match' do
          expect(path.count).to eq 8
          expect(path.slice(1,4).join(' ')).to eq '* IS THE *'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq '* IS THE *'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'train.aiml'
        end
      end
    end

    context 'patters contains a <set> element' do
      context 'set contains a matching value' do
        let(:input_pattern) { 'WHAT DO YOU THINK OF JEB BUSH' }

        it 'returns the matching path' do
          expect(path.count).to eq 10
          expect(path.slice(1,6).join(' ')).to eq 'WHAT DO YOU # <set>rival</set> #'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq 'WHAT DO YOU # <set>rival</set> #'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'rivals.aiml'
        end
      end

      context 'set contains a matching multi-word value' do
        let(:input_pattern) { 'IS ROAD RUNNER A BIRD' }

        it 'returns the matching path' do
          expect(path.count).to eq 8
          expect(path.slice(1,4).join(' ')).to eq 'IS <set>bird</set> A BIRD'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq 'IS <set>bird</set> A BIRD'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'knowledge.aiml'
        end
      end

      context 'set does not contains a matching value' do
        let(:input_pattern) { 'IS A VELOCIRAPTOR A BIRD' }
        
        it 'returns the appropriate path' do
          expect(path.count).to eq 8
          expect(path.slice(1,4).join(' ')).to eq 'IS * A BIRD'
        end

        it 'returns the matching pattern' do
          expect(path_match_result.pattern.to_s).to eq 'IS * A BIRD'
        end

        it 'returns the file where the matching pattern was found' do
          expect(path_match_result.source_file).to eq 'knowledge.aiml'
        end
      end

    end

    context 'non-default <that> value is specified' do
      let(:chat_session_id) { 1 }
      let(:that) { 'WHAT IS YOUR NAME' }
      let(:input_pattern) { 'JOE' }
     

      it 'returns the matching path' do
        expect(path.count).to eq 5
        expect(path.slice(1,2).join(' ')).to eq '<set>name</set> <that>WHAT IS YOUR NAME'
      end

      it 'returns the matching pattern' do
        expect(path_match_result.pattern.to_s).to eq '<set>name</set>'
      end
    end
 

  end

  def parse_input_pattern(input_pattern)
    Parsers::PatternXmlParser.new.parse(Nokogiri::XML("<pattern>#{input_pattern}</pattern>").root)
  end

end
