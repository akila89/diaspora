require 'spec_helper'

describe Api::UsersController do

  before do
    @user = alice
    sign_in :user, @user
    @controller.stub(:current_user).and_return(@user)
  end

 
  describe "routing to profiles" do
    it "routes /profile/:username to profile#show for username" do
      expect(:get => "/show/1/919a8164107702dca99bfc9db495ffab").to route_to(
        :controller => "Users",
        :action => "show",
        :id => "1",
        :access_token => "919a8164107702dca99bfc9db495ffab"
      )
  end
end
end
