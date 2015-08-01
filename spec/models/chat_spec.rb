require 'rails_helper'

describe Chat do

  describe '#respond' do

    context 'Chat with no history' do
      let(:chat) { Chat.new }

      it 'returns an expected response' do
        response = chat.respond('Hello')

        expect(response).to match /^Hi.*/
      end
    end
  end
end
