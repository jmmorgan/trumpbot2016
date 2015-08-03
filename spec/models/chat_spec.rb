require 'rails_helper'

describe Chat do

  describe '#respond' do

    context 'Chat with no history' do
      let(:chat) { Chat.new }

      it 'returns an expected response' do
        response = chat.respond('Hello')

        expect(response).to match /^Hi.*/
      end

      context 'template contains bot element' do

        it 'returns the expected response' do
          response = chat.respond('What is your name?')

          expect(response).to match /TrumpBot\.$/
        end
      end

      context 'template contains get and set elements' do

        it 'returns the expected response' do
          response = chat.respond('How old are you?')

          expect(response).to match /I'm \d+ years old\.$/
        end
      end

      context 'template contains a condition' do

        it 'returns the expected response' do
          response = chat.respond('Are you on Facebook?')

          expect(response).to match /My Facebook page/
        end
      end

      context 'template contains a think element' do

        it 'returns the expected response' do
          response = chat.respond('My name is Joe')

          expect(response).to match /\bJoe\b/
        end
      end
    end
  end

  describe 'JSON serialization/deserialization' do
    let(:chat_in) { Chat.new }
    let(:requests) { ['Good', 'Bad', 'Ugly'] }
    let(:responses) { ['Clint Eastwood', 'Lee Van Cleef', 'Eli Wallach'] }

    before do
      chat_in.requests = requests
      chat_in.responses = responses
      @chat_out = Chat.from_json(chat_in.to_json)
    end

    it 'writes/reads requests correctly' do
      expect(chat_in.requests).to eq requests
      expect(@chat_out.requests).to eq requests
    end

    it 'writes/reads responses correctly' do
      expect(chat_in.responses).to eq responses
      expect(@chat_out.responses).to eq responses
    end
  end

end
