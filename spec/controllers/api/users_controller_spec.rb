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
        get 'get_user_person_list'
        response.body.should == @expected
    end

    it "with an invalid access token" do
        @expected = {:error => "300"}.to_json
        get 'get_user_person_list' ,{'access_token'=> "100"}
        response.body.should == @expected
    end

    it "without profile read permission" do
	@scopes = Array  [ "comment_read", "comment_delete", "comment_write" ]
        @expected = {:error => "310"}.to_json
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
        get 'get_user_person_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        response.body.should == @expected
    end

    it "without registered app" do
	@scopes = Array  [ "comment_read", "comment_delete", "comment_write" ]
        @expected = {:error => "403"}.to_json
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
        get 'get_user_person_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'bob@192.168.1.3:3000' }
        response.body.should == @expected
    end    

  end

  describe "#get_user_person_list" do

    it "display person list" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
		@person_url = Person.all[2].url + "people/" + Person.all[2].guid
		@avatar = Person.all[2].url + "assets/user/default.png"
	        @expected={
            :first_name      => Person.all[2].first_name,
            :last_name       => Person.all[2].last_name,
            :diaspora_handle => "bob@192.168.1.3:3000",
            :location        => Person.all[2].location,
            :birthday        => Person.all[2].birthday,
            :gender          => Person.all[2].gender,
	    :bio	     => Person.all[2].bio,
	    :url	     => @person_url,
	    :avatar	     => @avatar
        }.to_json

        get 'get_user_person_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        response.body.should include(@expected)
    end
  end

  describe "#get_user_aspects_list" do

    it "display aspects list" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
            :aspect_name  => User.first.aspects.first.name,
            :id           => User.first.aspects.first.id,
            :user_id      => User.first.aspects.first.user_id
        }.to_json

        get 'get_user_aspects_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        response.body.should include(@expected)
    end
  end

  describe "#get_user_followed_tags_list" do

    it "display tag list" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @as=FactoryGirl.create(:tag_following)
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.last.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected=User.last.followed_tags.to_json

        get 'get_user_followed_tags_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => User.last.diaspora_handle }
        response.body.should include(@expected)
    end
  end
 
  describe "#get_user_details" do

    it "display user details" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
		@person_url = Person.first.url + "people/" + Person.first.guid
		@avatar = Person.first.url + "assets/user/default.png"
	        @expected={
            :first_name      => Person.first.first_name,
            :last_name       => Person.first.last_name,
            :diaspora_handle => "alice@192.168.1.3:3000",
            :location        => Person.first.location,
            :birthday        => Person.first.birthday,
            :gender          => Person.first.gender,
	    :bio	     => Person.first.bio,
	    :url	     => @person_url,
	    :avatar	     => @avatar
        }.to_json


        get 'get_user_details' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        response.body.should include(@expected)
    end
  end

  describe "#get_user_person_handle_list" do

    it "display user person handle list" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
	     :handle  => "bob@192.168.1.3:3000"
	}.to_json

        get 'get_user_person_handle_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        response.body.should include(@expected)
    end
  end

  describe "#get_app_scopes_of_given_user" do

    it "display user app scopes" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected=[
	         "profile_read",
       		 "profile_delete",
        	 "profile_write"
	].to_json

        get 'get_app_scopes_of_given_user' ,{ 'access_token' => @at.token, 'id' => @rt.app_id, 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        response.body.should include(@expected)
    end
  end

  describe "#edit_email" do

    it "update email with given email address" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	@expected=User.first.email
        put 'edit_email' ,{ 'access_token' => @at.token, 'email' => 'alice@gmail.com', 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        User.first.email.should_not == @expected
    end
  end

  describe "#edit_first_name" do

    it "update first name with given first name" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	@expected=User.first.first_name
        put 'edit_first_name' ,{ 'access_token' => @at.token, 'first_name' => 'alice-test', 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        User.first.first_name.should_not == @expected
    end
  end

  describe "#edit_last_name" do

    it "update last name with given last name" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	@expected=User.first.last_name
        put 'edit_last_name' ,{ 'access_token' => @at.token, 'last_name' => 'alice-last', 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        User.first.last_name.should_not == @expected
    end
  end

  describe "#edit_user_location" do

    it "update user location with given location" do
	@scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
        @rt = FactoryGirl.create(:refresh_token, :user_guid=> Person.first.guid, :scopes=> @scopes)
        @at = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	@expected=Person.first.location
        put 'edit_user_location' ,{ 'access_token' => @at.token, 'location' => 'Moon', 'diaspora_handle' => 'alice@192.168.1.3:3000' }
        Person.first.location.should_not == @expected
    end
  end

end
