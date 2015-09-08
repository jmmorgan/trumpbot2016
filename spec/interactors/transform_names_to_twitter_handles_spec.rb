require 'rails_helper'

describe Interactors::TransformNamesToTwitterHandles do

  describe '#call' do
    let(:interactor) { Interactors::TransformNamesToTwitterHandles.new(input_text) }

    describe '#call' do
      let(:input_text) {
        "Hillary Clinton's email scandal is not as bad as Obamacare, but better than Obama " +
        "and worse than Scott Walker's dive in the polls"
      }

      it 'transforms the given text' do
        expect(interactor.call()).to eq "@HillaryClinton's email scandal is not as bad as Obamacare, " +
                                        "but better than @BarackObama and worse than @ScottWalker's " +
                                        "dive in the polls"
      end
    end
  end
end
