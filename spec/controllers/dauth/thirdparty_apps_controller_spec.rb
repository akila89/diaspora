require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Dauth::ThirdpartyAppsController do

  # This should return the minimal set of attributes required to create a valid
  # Dauth::ThirdpartyApp. As you add validations to Dauth::ThirdpartyApp, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "app_id" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Dauth::ThirdpartyAppsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all dauth_thirdparty_apps as @dauth_thirdparty_apps" do
      thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
      get :index, {}, valid_session
      assigns(:dauth_thirdparty_apps).should eq([thirdparty_app])
    end
  end

  describe "GET show" do
    it "assigns the requested dauth_thirdparty_app as @dauth_thirdparty_app" do
      thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
      get :show, {:id => thirdparty_app.to_param}, valid_session
      assigns(:dauth_thirdparty_app).should eq(thirdparty_app)
    end
  end

  describe "GET new" do
    it "assigns a new dauth_thirdparty_app as @dauth_thirdparty_app" do
      get :new, {}, valid_session
      assigns(:dauth_thirdparty_app).should be_a_new(Dauth::ThirdpartyApp)
    end
  end

  describe "GET edit" do
    it "assigns the requested dauth_thirdparty_app as @dauth_thirdparty_app" do
      thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
      get :edit, {:id => thirdparty_app.to_param}, valid_session
      assigns(:dauth_thirdparty_app).should eq(thirdparty_app)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Dauth::ThirdpartyApp" do
        expect {
          post :create, {:dauth_thirdparty_app => valid_attributes}, valid_session
        }.to change(Dauth::ThirdpartyApp, :count).by(1)
      end

      it "assigns a newly created dauth_thirdparty_app as @dauth_thirdparty_app" do
        post :create, {:dauth_thirdparty_app => valid_attributes}, valid_session
        assigns(:dauth_thirdparty_app).should be_a(Dauth::ThirdpartyApp)
        assigns(:dauth_thirdparty_app).should be_persisted
      end

      it "redirects to the created dauth_thirdparty_app" do
        post :create, {:dauth_thirdparty_app => valid_attributes}, valid_session
        response.should redirect_to(Dauth::ThirdpartyApp.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved dauth_thirdparty_app as @dauth_thirdparty_app" do
        # Trigger the behavior that occurs when invalid params are submitted
        Dauth::ThirdpartyApp.any_instance.stub(:save).and_return(false)
        post :create, {:dauth_thirdparty_app => { "app_id" => "invalid value" }}, valid_session
        assigns(:dauth_thirdparty_app).should be_a_new(Dauth::ThirdpartyApp)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Dauth::ThirdpartyApp.any_instance.stub(:save).and_return(false)
        post :create, {:dauth_thirdparty_app => { "app_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested dauth_thirdparty_app" do
        thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
        # Assuming there are no other dauth_thirdparty_apps in the database, this
        # specifies that the Dauth::ThirdpartyApp created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Dauth::ThirdpartyApp.any_instance.should_receive(:update_attributes).with({ "app_id" => "MyString" })
        put :update, {:id => thirdparty_app.to_param, :dauth_thirdparty_app => { "app_id" => "MyString" }}, valid_session
      end

      it "assigns the requested dauth_thirdparty_app as @dauth_thirdparty_app" do
        thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
        put :update, {:id => thirdparty_app.to_param, :dauth_thirdparty_app => valid_attributes}, valid_session
        assigns(:dauth_thirdparty_app).should eq(thirdparty_app)
      end

      it "redirects to the dauth_thirdparty_app" do
        thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
        put :update, {:id => thirdparty_app.to_param, :dauth_thirdparty_app => valid_attributes}, valid_session
        response.should redirect_to(thirdparty_app)
      end
    end

    describe "with invalid params" do
      it "assigns the dauth_thirdparty_app as @dauth_thirdparty_app" do
        thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Dauth::ThirdpartyApp.any_instance.stub(:save).and_return(false)
        put :update, {:id => thirdparty_app.to_param, :dauth_thirdparty_app => { "app_id" => "invalid value" }}, valid_session
        assigns(:dauth_thirdparty_app).should eq(thirdparty_app)
      end

      it "re-renders the 'edit' template" do
        thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Dauth::ThirdpartyApp.any_instance.stub(:save).and_return(false)
        put :update, {:id => thirdparty_app.to_param, :dauth_thirdparty_app => { "app_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested dauth_thirdparty_app" do
      thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
      expect {
        delete :destroy, {:id => thirdparty_app.to_param}, valid_session
      }.to change(Dauth::ThirdpartyApp, :count).by(-1)
    end

    it "redirects to the dauth_thirdparty_apps list" do
      thirdparty_app = Dauth::ThirdpartyApp.create! valid_attributes
      delete :destroy, {:id => thirdparty_app.to_param}, valid_session
      response.should redirect_to(dauth_thirdparty_apps_url)
    end
  end

end
