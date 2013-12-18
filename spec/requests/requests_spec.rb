require 'spec_helper'

describe 'OnePad APIs' do
  fixtures :pads

  describe 'POST /create.json' do
    it 'は作成したPadを返す (201)' do
      post '/create.json', format: 'json', content: 'こんにちは'
      body = JSON(response.body).symbolize_keys
      expect(response.status).to eq 201
      expect(body[:content]).to include 'こんにちは'
    end
  end

  describe 'GET /test-pad1.json' do
    it 'は既存のPadを返す (200)' do
      get '/test-pad1.json'
      body = JSON(response.body).symbolize_keys
      expect(response.status).to eq 200
      expect(body[:content]).to eq '初日の出スポット'
    end
  end

  describe 'GET /test-pad1/2013-0101-0000.json' do
    it 'は既存のPadを返す (200)' do
      get '/test-pad1/2013-0101-0000.json'
      body = JSON(response.body).symbolize_keys
      expect(response.status).to eq 200
      expect(body[:content]).to eq 'あけました'
    end
  end
end
