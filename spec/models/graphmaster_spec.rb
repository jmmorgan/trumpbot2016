require 'spec_helper'
require 'rails_helper'

describe Graphmaster do

  describe '#get_matching_paths' do

    context 'pattern contains text only' do

      it 'returns the matching path' do
        path = GRAPHMASTER.get_matching_paths('HOW DO YOU WORK')
        expect(path.count).to eq 7
        expect(path.slice(1,4).join(' ')).to eq 'HOW DO YOU WORK'
      end
    end
  end

end
