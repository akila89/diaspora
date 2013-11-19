require 'spec_helper'

describe Api::UsersController do

  before do
    @user = alice
    sign_in :user, @user
    @controller.stub(:current_user).and_return(@user)
  end

  describe "Accessing api methods" do
    it "without an access token'" do
        @expected = {:error => "300"}.to_json
        get 'getUserpersonList'
        response.body.should == @expected
    end

    it "with an invalid access token" do
        @expected = {:error => "300"}.to_json
        get 'getUserpersonList' ,{'access_token'=> "100"}
        response.body.should == @expected
    end

    it "without profile read permission" do
        @expected = {:error => "310"}.to_json
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
        get 'getUserpersonList' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@localhost:9887' }
        response.body.should == @expected
    end

    it "without registered app" do
        @expected = {:error => "403"}.to_json
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
        get 'getUserpersonList' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'eve@localhost:9887' }
        response.body.should == @expected
    end    

  end
 
#  describe "Call for api methods without access token" do
#    it "routes 'getUserpersonList/:diaspora_handle/:access_token'" do
#        @expected = { 
#        	:flashcard  => @flashcard,
#        	:lesson     => @lesson,
#        	:success    => true
#        }.to_json
#
#        rt = FactoryGirl.create(:refresh_token)
#	at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
#        
#        #//@refresh_tuple=FactoryGirl.create(:refresh_token)
#       # @access_tuple=FactoryGirl.create(:access_token)
# 	
#        get 'getUserpersonList' ,{'access_token'=>at.token}
#        response.body.should == @expected
#    end
#    it "routes 'getUserpersonList/:diaspora_handle/:access_token'" do
#        get :getUserpersonList      
#    end
#  end

end
