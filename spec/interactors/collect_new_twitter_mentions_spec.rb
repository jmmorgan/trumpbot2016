require 'rails_helper'

describe Interactors::CollectNewTwitterMentions do

  describe '#call' do
    let(:mentions_timeline) { build_mentions_timeline }
    let(:twitter_client) { double('twitter_client', mentions_timeline: mentions_timeline) }
    let(:collect_new_twitter_mentions)  { Interactors::CollectNewTwitterMentions.new({twitter_client: twitter_client}) }

    before do
      collect_new_twitter_mentions.call
    end

    it 'saves the tweets to the database' do
      retrieved_mentions = TwitterMention.all
      expect(retrieved_mentions.count).to eq mentions_timeline.count
      mentions_timeline.each do |mention|
        expect(TwitterMention.find_by(twitter_id: mention.id).text).to eq mention.text
      end
    end

    it 'does not re-save the same tweet as a duplicate' do
      collect_new_twitter_mentions.call
      retrieved_mentions = TwitterMention.all
      expect(retrieved_mentions.map(&:twitter_id)).to eq mentions_timeline.map(&:id)
    end

  end

  def build_mentions_timeline
    result = []
    5.times do |i|
      result << double('tweet', id: i + 1, text: "Message #{i}", 
        user: double('user', id: i + 1, screen_name: "real#{i}"))
    end

    result
  end
end
