require 'spec_helper'

describe "pads/show" do
  before(:each) do
    @pad = assign(:pad, stub_model(Pad,
      :key => "Key",
      :revision => "Revision",
      :content => "MyText",
      :is_autosaved => false,
      :is_deleted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Key/)
    rendered.should match(/Revision/)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
