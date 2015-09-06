require 'rails_helper'

describe Interactors::QueryBot do
  let(:query_bot) { Interactors::QueryBot.new(request)}

  describe '#call' do

    context 'blue sky' do
      let(:request) { {input: 'Hello, there.'} }

      before do
        @response = query_bot.call
      end

      it 'returns a ChatResponse' do
        expect(@response).to be_a(ChatResponse)
      end

      it 'populates inputs on the ChatResponse' do
        expect(@response.inputs).to eq [request[:input]]
      end

      it 'populates outputs on the ChatResponse' do
        expect(@response.outputs.count).to eq 1
      end

      it 'populates category trees on the ChatResponse' do
        expect(@response.category_trees.count).to eq 1
      end

      it 'populates source files on the ChatResponse' do
        expect(@response.source_files).to eq ['reductions1.aiml']
      end

      it 'populates THAT on the ChatResponse' do
        expect(@response.that.length).to be > 0
      end
    end

    context 'request contains THAT' do
      let(:request) { {input: 'Joe', that: 'WHAT IS YOUR NAME'} }

      before do
        @response = query_bot.call
      end

      it 'returns a context appropriate response' do
        expect(@response.outputs.last).to match /Joe/
      end
    end

  end

end
