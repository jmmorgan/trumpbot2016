require 'rails_helper'

RSpec.describe ChatSession, type: :model do
  
  describe '#chat_json' do
    let(:requests) { ['Good', 'Bad', 'Ugly'] }
    let(:responses) { ['Clint Eastwood', 'Lee Van Cleef', 'Eli Wallach'] }
    let(:chat_in) { 
      chat = Chat.new(nil)
      chat.requests = requests
      chat.responses = responses
      chat
    }
    
    it 'supports serializing/deserializing a Chat' do
      chat_session = ChatSession.create(session_id: 'foo', chat_json: chat_in.to_json)
      chat_out = ChatSession.find_by(session_id: 'foo').chat
      expect(chat_in.requests).to eq chat_out.requests
      expect(chat_in.responses).to eq chat_out.responses
    end
  end

end
