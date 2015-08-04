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

          expect(response).to match /\d+ years old\.$/
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

      context 'template contains a vocabulary element' do

        it 'returns the expected response' do
          response = chat.respond('VOCABULARY')

          expect(response).to match /I am able to recognize \d+ individual words/
        end
      end

      context 'template contains a size element' do

        it 'returns the expected response' do
          response = chat.respond('SIZE')

          expect(response).to match /My brain contains \d+ categories/
        end
      end

      context 'template contains a uppercase element' do

        it 'returns the expected response' do
          response = chat.respond('SPELL baseball')

          expect(response).to match /baseball: B A S E B A L L/
        end
      end

      context 'template contains a get_likes element' do

        it 'returns the expected response' do
          response = chat.respond('I like to fish')
          response = chat.respond('Do I like reading?')

          expect(response).to match /I know you like fish/
        end
      end

      context 'template contains a br element' do

        it 'returns the expected response' do
          response = chat.respond('SING')

          expect(response).to match /<br\/>/
        end
      end

      context 'template contains an anchor tag' do

        it 'returns the expected response' do
          response = chat.respond('HOW DO I EXECUTE YOU')

          expect(response).to match /Maybe you should read <a /
        end
      end

      context 'template contains a normalize tag' do

        it 'returns the expected response' do
          response = chat.respond('NORMALIZE e l v i s')

          expect(response).to match /elvis/
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
