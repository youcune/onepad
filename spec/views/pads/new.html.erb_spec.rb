require 'spec_helper'

describe "pads/new" do
  before(:each) do
    assign(:pad, stub_model(Pad,
      :key => "MyString",
      :revision => "MyString",
      :content => "MyText",
      :is_autosaved => false,
      :is_deleted => false
    ).as_new_record)
  end

  it "renders new pad form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", pads_path, "post" do
      assert_select "input#pad_key[name=?]", "pad[key]"
      assert_select "input#pad_revision[name=?]", "pad[revision]"
      assert_select "textarea#pad_content[name=?]", "pad[content]"
      assert_select "input#pad_is_autosaved[name=?]", "pad[is_autosaved]"
      assert_select "input#pad_is_deleted[name=?]", "pad[is_deleted]"
    end
  end
end
