require 'spec_helper'

describe Api::UsersController do


  describe "Accessing api methods" do
    user = FactoryGirl.create(:user)
    user_two = FactoryGirl.create(:user)
	  scopes = Array  [ "comment_read", "comment_delete", "comment_write" ]
    rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
    at = FactoryGirl.create(:access_token, :refresh_token => rt.token)

    it "without an access token'" do
      expected = {:error => "300"}.to_json
      get 'get_user_contact_list'
      response.body.should == expected
    end

    it "with an invalid access token" do
      expected = {:error => "300"}.to_json
      get 'get_user_contact_list' ,{'access_token'=> "100"}
      response.body.should == expected
    end

    it "without profile read permission" do
      expected = {:error => "310"}.to_json
      get 'get_user_contact_list' ,{ 'access_token' => at.token, 'diaspora_handle' => user.diaspora_handle }
      response.body.should == expected
    end

    it "without profile write permission" do
      expected = {:error => "311"}.to_json
      put 'edit_email' ,{ 'access_token' => at.token, 'email' => 'alice@gmail.com', 'diaspora_handle' => user.diaspora_handle }
      response.body.should == expected
    end

    it "without registered app" do
      expected = {:error => "403"}.to_json
      get 'get_user_contact_list' ,{ 'access_token' => at.token, 'diaspora_handle' => user_two.diaspora_handle }
      response.body.should == expected
    end    

  end

  describe "#get_user_contact_list" do

    it "display contact list" do
      user = FactoryGirl.create(:user)
      user_two = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:contact, :person => user_two.person, :user => user)
	    scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
		  person_url = user_two.person.url + "people/" + user_two.person.guid
		  avatar = user_two.person.url + "assets/user/default.png"
	      expected={
          :first_name      => user_two.person.first_name,
          :last_name       => user_two.person.last_name,
          :diaspora_handle => user_two.diaspora_handle,
          :location        => user_two.person.location,
          :birthday        => user_two.person.birthday,
          :gender          => user_two.person.gender,
	        :bio	           => user_two.person.bio,
	        :url	           => person_url,
	        :avatar	         => avatar
        }.to_json

      get 'get_user_contact_list' ,{ 'access_token' => at.token, 'diaspora_handle' => user.diaspora_handle }
      response.body.should include(expected)
    end
  end

  describe "#get_user_aspects_list" do

    it "display aspects list" do
      scopes = Array [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> User.first, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
         expected={
          :aspect_name => User.first.aspects.first.name,
          :id => User.first.aspects.first.id,
          :user_id => User.first.aspects.first.user_id
        }.to_json

      get 'get_user_aspects_list' ,{ 'access_token' => at.token, 'diaspora_handle' => User.first.diaspora_handle }
      response.body.should include(expected)
    end
  end

  describe "#get_user_followed_tags_list" do

    it "display tag list" do
      user = FactoryGirl.create(:user)
	    scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
      as = FactoryGirl.create(:tag_following)
      rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
	      expected=user.followed_tags.to_json

      get 'get_user_followed_tags_list' ,{ 'access_token' => at.token, 'diaspora_handle' => user.diaspora_handle }
      response.body.should include(expected)
    end
  end
 
  describe "#get_user_details" do

    it "display user details" do
      user = FactoryGirl.create(:user)
	    scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
		  person_url = user.person.url + "people/" + user.guid
		  avatar = user.person.url + "assets/user/default.png"
	      expected={
          :first_name      => user.person.first_name,
          :last_name       => user.person.last_name,
          :diaspora_handle => user.diaspora_handle,
          :location        => user.person.location,
          :birthday        => user.person.birthday,
          :gender          => user.person.gender,
	        :bio	           => user.person.bio,
	        :url	           => person_url,
	        :avatar	         => avatar
        }.to_json


      get 'get_user_details' ,{ 'access_token' => at.token, 'diaspora_handle' => user.diaspora_handle }
      response.body.should include(expected)
    end
  end

  describe "#get_user_contact_handle_list" do

    it "display user person handle list" do
      user = FactoryGirl.create(:user)
      user_two = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:contact, :person=> user_two.person, :user=> user)
	    scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
	      expected={
	        :handle  => user_two.diaspora_handle
	      }.to_json

      get 'get_user_contact_handle_list' ,{ 'access_token' => at.token, 'diaspora_handle' => user.diaspora_handle }
      response.body.should include(expected)
    end
  end

  describe "#get_app_scopes_of_given_user" do

    it "display user app scopes" do
      user = FactoryGirl.create(:user)
	    scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
	      expected=[
	        "profile_read",
       	  "profile_delete",
          "profile_write"
	      ].to_json

      get 'get_app_scopes_of_given_user' ,{ 'access_token' => at.token, 'id' => rt.app_id, 'diaspora_handle' => user.diaspora_handle }
      response.body.should include(expected)
    end

    it "display error 'unauthorized' access" do
      user = FactoryGirl.create(:user)
      user_two = FactoryGirl.create(:user)
	    scopes = Array  [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> user, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
      rt1 = FactoryGirl.create(:refresh_token, :user=> user_two, :scopes=> scopes)
      at1 = FactoryGirl.create(:access_token, :refresh_token => rt1.token)
	      expected={
	        :error  => "401"
	      }.to_json

      get 'get_app_scopes_of_given_user' ,{ 'access_token' => at.token, 'id' => rt1.app_id, 'diaspora_handle' => user.diaspora_handle }
      response.body.should include(expected)
    end

  end


  describe "#edit_email" do

    it "update email with given email address" do
      scopes = Array [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> User.first, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
      expected=User.first.email
      put 'edit_email' ,{ 'access_token' => at.token, 'email' => 'alice@gmail.com', 'diaspora_handle' => User.first.diaspora_handle }
      User.first.email.should_not == expected
    end

    it "display 'unsupported type' error for invalid email address" do
      scopes = Array [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> User.first, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
         expected={
         :error => "402"
         }.to_json
      put 'edit_email' ,{ 'access_token' => at.token, 'email' => 'alice', 'diaspora_handle' => User.first.diaspora_handle }
      User.first.email.should_not == expected
    end
  end

  describe "#edit_first_name" do

    it "update first name with given first name" do
      scopes = Array [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> User.first, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
         expected=User.first.first_name
      put 'edit_first_name' ,{ 'access_token' => at.token, 'first_name' => 'alice-test', 'diaspora_handle' => User.first.diaspora_handle }
      User.first.first_name.should_not == expected
    end
  end

  describe "#edit_last_name" do

    it "update last name with given last name" do
      scopes = Array [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> User.first, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
         expected=User.first.last_name
      put 'edit_last_name' ,{ 'access_token' => at.token, 'last_name' => 'alice-last', 'diaspora_handle' => User.first.diaspora_handle }
      User.first.last_name.should_not == expected
    end
  end

  describe "#edit_user_location" do

    it "update user location with given location" do
      scopes = Array [ "profile_read", "profile_delete", "profile_write" ]
      rt = FactoryGirl.create(:refresh_token, :user=> User.first, :scopes=> scopes)
      at = FactoryGirl.create(:access_token, :refresh_token => rt.token)
         expected=Person.first.location
      put 'edit_user_location' ,{ 'access_token' => at.token, 'location' => 'Moon', 'diaspora_handle' => User.first.diaspora_handle }
      Person.first.location.should_not == expected
    end
  end

end
