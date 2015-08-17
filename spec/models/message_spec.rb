require 'rails_helper'

RSpec.describe Message, type: :model do
  subject { Message.new }

  describe 'Validations' do
    it { should validate_presence_of(:chat_session_id) }
    it { should validate_presence_of(:message_text) }
  end

  describe 'Associations' do
    it { should belong_to(:chat_session) }
  end
  
end
