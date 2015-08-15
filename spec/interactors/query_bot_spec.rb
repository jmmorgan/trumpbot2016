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

      it 'populates matched patterns on the ChatResponse' do
        expect(@response.matched_patterns.count).to eq 1
      end

      it 'populates source files on the ChatResponse' do
        expect(@response.source_files).to eq ['reductions1.aiml']
      end
    end

  end

end
