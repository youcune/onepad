require 'spec_helper'

describe 'pads/show.html.erb' do
  it 'は新規作成の場合、内容を出力する' do
    assign :pad, Pad.new(key: 'create', content: PadsController::DEFAULT_CONTENT)
    render
    expect(rendered).to include '<h1>OnePadへようこそ！</h1>'
    expect(rendered).to include '# OnePadへようこそ！'
  end

  it 'は既存の内容を表示する場合、空で出力する' do
    assign :pad, Pad.new(key: 'test-pad1', content: PadsController::DEFAULT_CONTENT)
    render
    expect(rendered).not_to include '<h1>OnePadへようこそ！</h1>'
    expect(rendered).not_to include '# OnePadへようこそ！'
  end
end
