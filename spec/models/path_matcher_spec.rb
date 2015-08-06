require 'spec_helper'
require 'rails_helper'

describe PathMatcher do
  let(:path_matcher) { PathMatcher.new }

  describe '#get_matching_path' do

    context 'pattern contains text only' do

      it 'returns the matching path' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'HOW DO YOU WORK')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 8
        expect(path.slice(1,4).join(' ')).to eq 'HOW DO YOU WORK'
      end
    end

    context 'pattern contains one trailing *' do

      it 'returns the matching path' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'MY FAVORITE COLOR IS PLAID')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 9
        expect(path.slice(1,5).join(' ')).to eq 'MY FAVORITE COLOR IS *'
      end
    end

    context 'pattern contains one leading *' do

      it 'returns the matching path' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'COWS PRODUCE MILK')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 6
        expect(path.slice(1,2).join(' ')).to eq '* MILK'
      end
    end

    context 'pattern contains leading and trailing *' do

      it 'returns the matching path' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'TRIXIEBEAN GAVE ME A SCARE')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 7
        expect(path.slice(1,3).join(' ')).to eq '* GAVE *'
      end
    end

    context 'pattern contains $' do
      it 'returns the matching path' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'EMAIL JON TO SAY I AM GOING')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 9
        expect(path.slice(1,5).join(' ')).to eq '$EMAIL * TO SAY *'
      end
    end

    context 'pattern contains #' do
      it 'returns the matching path when words are matched' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'IN WHICH ROOMS DO YOU WATCH PORN')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 10
        expect(path.slice(1,6).join(' ')).to eq '# DO YOU WATCH PORN #'
      end

      it 'returns the matching path when zero words match' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'DO YOU WATCH PORN')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 10
        expect(path.slice(1,6).join(' ')).to eq '# DO YOU WATCH PORN #'
      end
    end

    context 'pattern contains _' do
      it 'returns the matching path when words are matched' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'WHAT IS THE MONETARY UNIT IN ENGLAND')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 10
        expect(path.slice(1,6).join(' ')).to eq 'WHAT IS THE MONETARY _ ENGLAND'
      end

      it 'returns the default when zero words match' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'WHAT IS THE MONETARY ENGLAND')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 8
        expect(path.slice(1,4).join(' ')).to eq '* IS THE *'
      end
    end

    context 'patters contains a <set> element' do
      it 'returns the matching path when set contains a matching value' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'WHAT DO YOU THINK OF JEB BUSH')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 10
        expect(path.slice(1,6).join(' ')).to eq 'WHAT DO YOU # <set>rival</set> #'
      end

      it 'returns the matching path when set contains a matching multi-word value' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'IS ROAD RUNNER A BIRD')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 8
        expect(path.slice(1,4).join(' ')).to eq 'IS <set>bird</set> A BIRD'
      end

      it 'returns the appropriate path when set does not contains a matching value' do
        path_match_result = path_matcher.get_matching_path(GRAPHMASTER, 'WHAT DOES A VELOCIRAPTOR SAY')
        path = path_match_result.path
        #puts path
        expect(path.count).to eq 8
        expect(path.slice(1,4).join(' ')).to eq 'WHAT DOES A *'
      end

    end


  end

end
