require 'rails_helper'

describe TrainingController do

  describe 'GET index' do

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

  end

  describe 'POST index' do
    let(:query_bot) { double('query_bot', call: true)}

    before do
      allow(Interactors::QueryBot).to receive(:new) { query_bot }
    end

    it 'renders the index template' do
      post :index
      expect(response).to render_template('index')
    end

    context 'input is present' do
      it 'invokes a QueryBot interactor' do
        post :index, input: "Who are you?"
        expect(query_bot).to have_received(:call)
      end
    end

    context 'input is not present' do
      it 'does not invoke a QueryBot interactor' do
        post :index
        expect(query_bot).to_not have_received(:call)
      end
    end

  end

end
