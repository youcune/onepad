require 'spec_helper'

describe "pads/index" do
  before(:each) do
    assign(:pads, [
      stub_model(Pad,
        :key => "Key",
        :revision => "Revision",
        :content => "MyText",
        :is_autosaved => false,
        :is_deleted => false
      ),
      stub_model(Pad,
        :key => "Key",
        :revision => "Revision",
        :content => "MyText",
        :is_autosaved => false,
        :is_deleted => false
      )
    ])
  end

  it "renders a list of pads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "Revision".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
