require 'spec_helper'

describe ManifestsController do

  before do
    @user = alice
    sign_in :user, @user
    @controller.stub(:current_user).and_return(@user)
  end

  describe '#download' do
    it "downlods a 'json' file" do
      manifest = FactoryGirl.create(:manifest, :dev => @user)
      get :download, :id => manifest.id
      response.header['Content-Type'].should eql 'application/json'
    end
  end
end
