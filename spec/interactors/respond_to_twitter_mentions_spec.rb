require 'rails_helper'

describe Interactors::RespondToTwitterMentions do

  describe '#call' do
    let(:chat_response) { double('chat_response', outputs: ["Ok"]) }
    let(:query_bot) { double('query_bot', call: chat_response) }
    let(:twitter_client) { double('twitter_client', update: nil) }
    let(:respond_to_twitter_mentions)  { Interactors::RespondToTwitterMentions.new({twitter_client: twitter_client}) }

    before do
      allow(Interactors::QueryBot).to receive(:new).and_return(query_bot)
      5.times do |i|
        TwitterMention.create(screen_name: "Me", text: "Oh #{i}", twitter_id: i + 1, replied: (i%2==0))
      end
      respond_to_twitter_mentions.call
    end

    it 'creates a response for each mention where replied==false' do
      expect(twitter_client).to have_received(:update).twice
    end

    it 'sets replied=true for tweets to which it responds' do
      expect(TwitterMention.where(replied: true).count).to eq 5
    end

    context 'response exceeds 140 character limit' do
      let(:chat_response) { double('chat_response', outputs: ["Ok" * 200]) }

      it 'breaks up the response into sub 140-character chunks' do
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 1/4", {:in_reply_to_status_id=>2}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 2/4", {:in_reply_to_status_id=>2}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 3/4", {:in_reply_to_status_id=>2}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 4/4", {:in_reply_to_status_id=>2}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 1/4", {:in_reply_to_status_id=>4}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 2/4", {:in_reply_to_status_id=>4}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 3/4", {:in_reply_to_status_id=>4}).once
        expect(twitter_client).to have_received(:update).with("@Me #{"Ok" * 66} 4/4", {:in_reply_to_status_id=>4}).once
      end

    end

  end
end
