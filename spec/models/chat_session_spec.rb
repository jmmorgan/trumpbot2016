require 'rails_helper'

RSpec.describe ChatSession, type: :model do
  let(:graphmaster) { Graphmaster.send(:new, false) }

  describe 'Associations' do
    it { should have_many(:messages) }
  end
  
  describe '#respond' do

    before do
      allow(Graphmaster).to receive(:instance).and_return(graphmaster)

      load_categories(graphmaster)
    end

    context 'Chat with no history' do
      let(:chat_session) { ChatSession.new }

      it 'returns an expected response' do
        response = chat_session.respond('Hello')

        expect(response.outputs.first).to match /^Hi.*/
      end

      context 'template contains bot element' do

        it 'returns the expected response' do
          response = chat_session.respond('What is your name?')

          expect(response.outputs.first).to match /TrumpBot\.$/
        end
      end

      context 'template contains get and set elements' do

        it 'returns the expected response' do
          response = chat_session.respond('How old are you?')

          expect(response.outputs.first).to match /\d+ years old\.$/
        end
      end

      context 'template contains a condition' do

        it 'returns the expected response' do
          response = chat_session.respond('Are you on Facebook?')

          expect(response.outputs.first).to match /My Facebook page/
        end
      end

      context 'template contains a think element' do

        it 'returns the expected response' do
          response = chat_session.respond('My name is Joe')

          expect(response.outputs.first).to match /\bJoe\b/
        end
      end

      context 'template contains a vocabulary element' do

        it 'returns the expected response' do
          response = chat_session.respond('VOCABULARY')

          expect(response.outputs.first).to match /I am able to recognize \d+ individual words/
        end
      end

      context 'template contains a size element' do

        it 'returns the expected response' do
          response = chat_session.respond('SIZE')

          expect(response.outputs.first).to match /My brain contains \d+ categories/
        end
      end

      context 'template contains a uppercase element' do

        it 'returns the expected response' do
          response = chat_session.respond('SPELL baseball')
          #puts response
          expect(response.outputs.first).to match /Baseball: B A S E B A L L/
        end
      end

      context 'template contains a get_likes element' do

        it 'returns the expected response' do
          response = chat_session.respond('I like to fish')
          response = chat_session.respond('Do I like reading?')

          expect(response.outputs.first).to match /I know you like fish/
        end
      end

      context 'template contains a br element' do

        it 'returns the expected response' do
          response = chat_session.respond('PIZZA HUT')

          expect(response.outputs.first).to match /<br\/>/
        end
      end

      context 'template contains an anchor element' do

        it 'returns the expected response' do
          response = chat_session.respond('HOW DO I EXECUTE YOU')

          expect(response.outputs.first).to match /\bread <a /
        end
      end

      context 'template contains a normalize element' do

        it 'returns the expected response' do
          response = chat_session.respond('NORMALIZE e l v i s')
          #puts response
          expect(response.outputs.first).to match /Elvis/
        end
      end

      context 'template contains an sr element' do

        it 'returns the expected response' do
          response = chat_session.respond('Hi, Donald')

          expect(response.outputs.first).to match /^Hi.+/
        end
      end

      context 'template contains a learn element' do

        it 'returns the expected response' do
          response = chat_session.respond('A turkey is from Turkey')

          expect(response.outputs.first).to match /Is it always from Turkey?/
        end

        it 'stores learned categories' do
          response = chat_session.respond('A turkey is from Turkey')

          learned_categories = chat_session.predicates['_learned_categories']
          expect(learned_categories.count).to eq 5
          expect(learned_categories[0]).to match /<pattern>WHERE IS A TURKEY \^\s*<\/pattern>/
          expect(learned_categories[1]).to match /<pattern>WHERE IS THAT TURKEY \^\s*<\/pattern>/
          expect(learned_categories[2]).to match /<pattern>WHAT IS FROM TURKEY \^\s*<\/pattern>/
          expect(learned_categories[3]).to match /<pattern>WHERE SHOULD I LOOK FOR A TURKEY \^\s*<\/pattern>/
          expect(learned_categories[4]).to match /<pattern>WHERE CAN I FIND A TURKEY \^\s*<\/pattern>/
        end

        it 'applies the new categories' do
          response = chat_session.respond('A peacock is from Connecticut')

          response = chat_session.respond('Where is a peacock found?')
          #puts response
          expect(response.outputs.first).to match /A peacock is from Connecticut/
        end

        it 'restricts learning to a specific chat session' do
          response = chat_session.respond('A woodchuck is from New York')

          response1 = chat_session.respond('Where is a woodchuck found?')
          response2 = ChatSession.new.respond('Where is a woodchuck found?')

          expect(response1.outputs.first).to match /a woodchuck is from New York/i
          expect(response2).not_to match /New York/i
        end
      end

      context 'template contains a set element' do

        context 'set element is preceded by a #' do

          context 'set matches on multiple words' do
            it 'returns the expected response' do
              response = chat_session.respond('What do you think of Mark Cuban?')

              expect(response.outputs.first).to match /^Mark Cuban/
            end

          end
        end
      end

      context 'category contains <that> element' do

        context "the bot asks for the user's name" do

          before do 
            response = chat_session.respond("What's my name?")

            expect(response.outputs.first).to match /What is your name\?$/

            chat_session.respond('Heisenberg')
          end

          it "sets the user's name" do
            response = chat_session.respond("What's my name?")

            expect(response.outputs.first).to match /Heisenberg/
          end
        end
      end
    end

    context 'categories are introduced that create a circular chain of srai references' do
      let(:chat_session) { ChatSession.new }

      before do

        template = Template.new
        srai = Srai.new
        srai.tokens = ["THIS IS BLUE"]
        template.tokens = [srai] # TODO: Refactor Template so all ivars can be set in initializer
        graphmaster.add_category(Category.new(parse_input_pattern("THIS IS GREEN"), That.new('*'), Topic.new('*'), template, 'udc.aiml'))

        template = Template.new
        srai = Srai.new
        srai.tokens = ["THIS IS BLUE"]
        template.tokens = [srai] # TODO: Refactor Template so all ivars can be set in initializer
        graphmaster.add_category(Category.new(parse_input_pattern("THIS IS RED"), That.new('*'), Topic.new('*'), template, 'udc.aiml'))

        template = Template.new
        srai = Srai.new
        srai.tokens = ["THIS IS RED"]
        template.tokens = [srai] # TODO: Refactor Template so all ivars can be set in initializer
        graphmaster.add_category(Category.new(parse_input_pattern("THIS IS BLUE"), That.new('*'), Topic.new('*'), template, 'udc.aiml'))
      end

      it 'exits gracefully from the loop' do
        response = chat_session.respond("This is green?")

        expect(response.outputs.first).to match /I'm having trouble understanding you\./
      end
    end
  end
end

def load_categories(graphmaster)
  path = "#{Rails.root}/spec/support/chat_session_spec.aiml"
  doc = Nokogiri::XML(File.open(path)) {|config| config.strict}

  doc.xpath('//category[not(ancestor::learn)]').each do |category_element| 
    category = Parsers::CategoryXmlParser.new.parse(category_element, File.basename(path))
    graphmaster.add_category(category)
  end
end
