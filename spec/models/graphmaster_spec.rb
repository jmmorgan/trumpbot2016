require 'spec_helper'
require 'rails_helper'

describe Graphmaster do

  describe '#get_matching_paths' do

    context 'pattern contains text only' do

      it 'returns the matching path' do
        path = GRAPHMASTER.get_matching_paths('HOW DO YOU WORK')
        puts path
        expect(path.count).to eq 7
        expect(path.slice(1,4).join(' ')).to eq 'HOW DO YOU WORK'
      end
    end

    context 'pattern contains one trailing *' do

      it 'returns the matching path' do
        path = GRAPHMASTER.get_matching_paths('MY FAVORITE COLOR IS PLAID')
        puts path
        expect(path.count).to eq 8
        expect(path.slice(1,5).join(' ')).to eq 'MY FAVORITE COLOR IS *'
      end
    end

    context 'pattern contains one leading *' do

      it 'returns the matching path' do
        path = GRAPHMASTER.get_matching_paths('COWS PRODUCE MILK')
        puts path
        expect(path.count).to eq 5
        expect(path.slice(1,2).join(' ')).to eq '* MILK'
      end
    end

    context 'pattern contains leading and trailing *' do

      it 'returns the matching path' do
        path = GRAPHMASTER.get_matching_paths('TRIXIE GAVE ME A SCARE')
        puts path
        expect(path.count).to eq 6
        expect(path.slice(1,3).join(' ')).to eq '* GAVE *'
      end
    end

    context 'pattern contains $' do
      it 'returns the matching path' do
        path = GRAPHMASTER.get_matching_paths('EMAIL JON TO SAY I AM GOING')
        puts path
        expect(path.count).to eq 8
        expect(path.slice(1,5).join(' ')).to eq '$EMAIL * TO SAY *'
      end
    end

    context 'pattern contains #' do
      it 'returns the matching path when words are matched' do
        path = GRAPHMASTER.get_matching_paths('IN WHICH ROOMS DO YOU WATCH PORN')
        puts path
        expect(path.count).to eq 9
        expect(path.slice(1,6).join(' ')).to eq '# DO YOU WATCH PORN #'
      end

      it 'returns the matching path when zero words match' do
        path = GRAPHMASTER.get_matching_paths('DO YOU WATCH PORN')
        puts path
        expect(path.count).to eq 9
        expect(path.slice(1,6).join(' ')).to eq '# DO YOU WATCH PORN #'
      end
    end
  end

end
