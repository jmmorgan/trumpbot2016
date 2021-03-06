require 'rails_helper'

describe WelcomeController do

  describe 'GET index' do

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

  end

  describe 'POST talk' do
    let(:query_bot) { double('query_bot', call: true)}

    before do
      allow(Interactors::QueryBot).to receive(:new) { query_bot }
    end

    it 'renders the index template' do
      xhr :post, :talk
      expect(response).to render_template('welcome/talk')
    end

    context 'input is present' do
      it 'invokes a QueryBot interactor' do
        xhr :post, :talk, input: "Who are you?"
        expect(query_bot).to have_received(:call)
      end
    end

    context 'input is not present' do
      it 'does not invoke a QueryBot interactor' do
        xhr :post, :talk
        expect(query_bot).to_not have_received(:call)
      end
    end

    context 'input is blank' do
      it 'does not invoke a QueryBot interactor' do
        xhr :post, :talk, input: '  '
        expect(query_bot).to_not have_received(:call)
      end
    end

  end

  describe 'POST reset' do

    it 'redirects to the root' do
      post :reset
      expect(response).to redirect_to('/')
    end

    it 'nils out current chat_session_id' do
      expect(session[:chat_session_id]).to be_nil
    end

  end

  describe 'POST download' do
    let (:chat_session) { double('chat_session', id: 1, update_attributes: true, transcript: "You: Hi\nTrumBot: Greetings", save!: true)}

    before do
      allow(ChatSession).to receive(:create!) { chat_session }
    end

    it 'does not render a template' do
      post :download
      expect(response).to render_template(nil)
    end

  end

end
