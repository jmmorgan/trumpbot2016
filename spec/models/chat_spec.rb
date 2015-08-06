require 'rails_helper'

describe Chat do

  describe '#respond' do

    context 'Chat with no history' do
      let(:chat) { Chat.new(1) }

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

      context 'template contains an anchor element' do

        it 'returns the expected response' do
          response = chat.respond('HOW DO I EXECUTE YOU')

          expect(response).to match /Maybe you should read <a /
        end
      end

      context 'template contains a normalize element' do

        it 'returns the expected response' do
          response = chat.respond('NORMALIZE e l v i s')

          expect(response).to match /elvis/
        end
      end

      context 'template contains an sr element' do

        it 'returns the expected response' do
          response = chat.respond('Hi, Donald')

          expect(response).to match /^Hi.+you/
        end
      end

      context 'template contains a learn element' do

        it 'returns the expected response' do
          response = chat.respond('A turkey is from Turkey')

          expect(response).to match /Is it always from Turkey?/
        end

        it 'stores learned categories' do
          response = chat.respond('A turkey is from Turkey')

          learned_categories = chat.predicates['_learned_categories']
          expect(learned_categories.count).to eq 5
          expect(learned_categories[0]).to match /<pattern>WHERE IS A TURKEY \^\s*<\/pattern>/
          expect(learned_categories[1]).to match /<pattern>WHERE IS THAT TURKEY \^\s*<\/pattern>/
          expect(learned_categories[2]).to match /<pattern>WHAT IS FROM TURKEY \^\s*<\/pattern>/
          expect(learned_categories[3]).to match /<pattern>WHERE SHOULD I LOOK FOR A TURKEY \^\s*<\/pattern>/
          expect(learned_categories[4]).to match /<pattern>WHERE CAN I FIND A TURKEY \^\s*<\/pattern>/
        end

        it 'applies the new categories' do
          response = chat.respond('A peacock is from Connecticut')

          response = chat.respond('Where is a peacock found?')

          expect(response).to match /a peacock is from Connecticut/
        end

        it 'restricts learning to a specific chat session' do
          response = chat.respond('A woodchuck is from New York')

          response1 = chat.respond('Where is a woodchuck found?')
          response2 = Chat.new(99).respond('Where is a woodchuck found?')

          expect(response1).to match /a woodchuck is from New York/i
          expect(response2).not_to match /New York/i
        end
      end

      context 'template contains a set element' do

        context 'set element is preceded by a #' do

          context 'set matches on multiple words' do
            it 'returns the expected response' do
              response = chat.respond('What do you think of Mark Cuban?')

              expect(response).to match /^Mark Cuban/
            end

          end
        end
      end
    end
  end

  describe 'JSON serialization/deserialization' do
    let(:chat_in) { Chat.new(1) }
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
