require 'rails_helper'

RSpec.describe Predicates, type: :model do
  let(:predicates) { Predicates.new }

  subject { predicates }
  
  describe 'Validations' do
    it { should validate_presence_of(:chat_session_id) }
    it { should validate_presence_of(:predicates_json) }
  end

  describe 'Associations' do
    it { should belong_to(:chat_session) }
  end

  describe 'set/get key/value pairs' do

    it 'sets a new key' do
      expect(predicates['foo']).to  be_nil
      predicates['foo'] = 'bar'
      expect(predicates['foo']).to eq 'bar'
    end

    it 'overwrites an existing key' do
      predicates['foo'] = 'moo'
      expect(predicates['foo']).to  eq 'moo'
      predicates['foo'] = 'bar'
      expect(predicates['foo']).to eq 'bar'
    end

    it 'persists key/value pairs to predicates_json' do
      predicates['joe'] = 'cool'
      predicates['trump'] = 'rich'
      predicates.chat_session_id = 99
      predicates.save!
      predicates_found = Predicates.find(predicates.id)
      expect(predicates_found.predicates_json).to match /"joe":"cool"/
      expect(predicates_found.predicates_json).to match /"trump":"rich"/
    end
  end

end
