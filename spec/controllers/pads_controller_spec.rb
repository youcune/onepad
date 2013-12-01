require 'spec_helper'

describe PadsController do

  # This should return the minimal set of attributes required to create a valid
  # Pad. As you add validations to Pad, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "key" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PadsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET new' do
    it 'はkeyがcreateの仮の@padを生成する' do
      get :new
      actual = assigns(:pad)
      expect(actual.key).to eq 'create'
      expect(actual.content).to eq PadsController::DEFAULT_CONTENT
      expect(response).to render_template :show
      expect(response.response_code).to eq 200
    end
  end

  describe 'POST create' do
    it 'は渡されたcontentの内容で@padを生成する' do
      post :create, { content: 'Hello!' }
      actual = assigns(:pad)
      expect(actual.content).to eq 'Hello!'
      expect(response).to render_template :show
      expect(response.response_code).to eq 200
    end

    it 'は不正な値が渡された場合、ステータス500を返す' do
      pending '実装中'
    end
  end

  describe "GET index" do
    it "assigns all pads as @pads" do
      pad = Pad.create! valid_attributes
      get :index, {}, valid_session
      assigns(:pads).should eq([pad])
    end
  end

  describe "GET show" do
    it "assigns the requested pad as @pad" do
      pad = Pad.create! valid_attributes
      get :show, {:id => pad.to_param}, valid_session
      assigns(:pad).should eq(pad)
    end
  end

  describe "GET new" do
    it "assigns a new pad as @pad" do
      get :new, {}, valid_session
      assigns(:pad).should be_a_new(Pad)
    end
  end

  describe "GET edit" do
    it "assigns the requested pad as @pad" do
      pad = Pad.create! valid_attributes
      get :edit, {:id => pad.to_param}, valid_session
      assigns(:pad).should eq(pad)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Pad" do
        expect {
          post :create, {:pad => valid_attributes}, valid_session
        }.to change(Pad, :count).by(1)
      end

      it "assigns a newly created pad as @pad" do
        post :create, {:pad => valid_attributes}, valid_session
        assigns(:pad).should be_a(Pad)
        assigns(:pad).should be_persisted
      end

      it "redirects to the created pad" do
        post :create, {:pad => valid_attributes}, valid_session
        response.should redirect_to(Pad.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved pad as @pad" do
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        post :create, {:pad => { "key" => "invalid value" }}, valid_session
        assigns(:pad).should be_a_new(Pad)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        post :create, {:pad => { "key" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested pad" do
        pad = Pad.create! valid_attributes
        # Assuming there are no other pads in the database, this
        # specifies that the Pad created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Pad.any_instance.should_receive(:update).with({ "key" => "MyString" })
        put :update, {:id => pad.to_param, :pad => { "key" => "MyString" }}, valid_session
      end

      it "assigns the requested pad as @pad" do
        pad = Pad.create! valid_attributes
        put :update, {:id => pad.to_param, :pad => valid_attributes}, valid_session
        assigns(:pad).should eq(pad)
      end

      it "redirects to the pad" do
        pad = Pad.create! valid_attributes
        put :update, {:id => pad.to_param, :pad => valid_attributes}, valid_session
        response.should redirect_to(pad)
      end
    end

    describe "with invalid params" do
      it "assigns the pad as @pad" do
        pad = Pad.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        put :update, {:id => pad.to_param, :pad => { "key" => "invalid value" }}, valid_session
        assigns(:pad).should eq(pad)
      end

      it "re-renders the 'edit' template" do
        pad = Pad.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        put :update, {:id => pad.to_param, :pad => { "key" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested pad" do
      pad = Pad.create! valid_attributes
      expect {
        delete :destroy, {:id => pad.to_param}, valid_session
      }.to change(Pad, :count).by(-1)
    end

    it "redirects to the pads list" do
      pad = Pad.create! valid_attributes
      delete :destroy, {:id => pad.to_param}, valid_session
      response.should redirect_to(pads_url)
    end
  end
end
