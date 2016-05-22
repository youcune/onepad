require "spec_helper"

describe 'Routing' do
  it 'GET / to pads#new' do
    expect(get('/')).to route_to controller: 'pads', action: 'new'
  end

  it 'POST /create.json to pads#create' do
    expect(post('/create.json')).to route_to controller: 'pads', action: 'create', format: 'json'
  end

  it 'GET /:key to pads#show' do
    expect(get('/test-pad1')).to route_to controller: 'pads', action: 'show', key: 'test-pad1'
  end

  it 'GET /:key.json to pads#show' do
    expect(get('/test-pad1.json')).to route_to controller: 'pads', action: 'show', key: 'test-pad1', format: 'json'
  end

  it 'GET /:key/:revision to pads#show' do
    expect(get('/test-pad1/2013-0101-0000')).to route_to controller: 'pads', action: 'show', key: 'test-pad1', revision: '2013-0101-0000'
  end

  it 'GET /:key/:revision to pads#show' do
    expect(get('/test-pad1/2013-0101-0000.json')).to route_to controller: 'pads', action: 'show', key: 'test-pad1', revision: '2013-0101-0000', format: 'json'
  end

  it 'PUT /test-pad1.json to pads#update' do
    expect(put('/test-pad1.json')).to route_to controller: 'pads', action: 'update', key: 'test-pad1', format: 'json'
  end
end
