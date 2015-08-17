class Predicates < ActiveRecord::Base
  attr_accessor :predicates_hash

  validates :chat_session_id, presence: true
  validates :predicates_json, presence: true

  belongs_to :chat_session

  def [](key)
    predicates_hash[key]
  end

  def []=(key, value)
    result = (predicates_hash[key] = value)
    build_json
  end

  def predicates_hash
    @predicates_hash ||= JSON.parse(self.predicates_json || '{}')
  end

  private

  def build_json
    self.predicates_json = predicates_hash.to_json
  end

end
