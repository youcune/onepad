require 'spec_helper'

describe 'OnePad APIs' do
  fixtures :pads

  describe 'POST /create.json' do
    it 'should create a new pad' do
      post create_pad_path(format: 'json', content: 'こんにちは')
      response
    end
  end

  describe 'GET /:key' do
    it 'should read specific pad' do
      get pad_path(key: 'pad1', format: 'json')
      response.status.should be(200)
    end
  end
end
