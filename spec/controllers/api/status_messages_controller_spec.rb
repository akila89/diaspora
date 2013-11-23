require 'spec_helper'

describe Api::StatusMessagesController do

  before do
    @user = alice
    sign_in :user, @user
    @controller.stub(:current_user).and_return(@user)
  end

  describe "#get_given_user_status_list" do

    it "display given user status list" do
	@status= FactoryGirl.create(:status_message,:author=>@user.person)
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @user.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
            :author_id      		=> @status.author_id,
            :comments_count       	=> @status.comments_count,
            :diaspora_handle_of_creator => @user.diaspora_handle,
            :status_id        		=> @status.id,
            :likes_count       		=> @status.likes_count,
            :text          		=> @status.text
        }.to_json

        get 'get_given_user_status_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => @user.diaspora_handle }
        response.body.should include(@expected)
    end
  end

  describe "#get_comments_for_status_message" do

    it "display given status comments" do
	@status= FactoryGirl.create(:status_message,:author=>@user.person)
        @comment = FactoryGirl.create(:comment,:post=>@status)
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @user.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
            :author_id      		=> @comment.author_id,
            :commentable_id       	=> @comment.commentable_id,
	    :id       			=> @comment.id,
            :likes_count 		=> @comment.likes_count,
            :text        		=> @comment.text
        }.to_json

        get 'get_comments_for_status_message' ,{ 'access_token' => @at.token,'id' => @status.id, 'diaspora_handle' => @user.diaspora_handle }
        response.body.should include(@expected)
    end
  end

  describe "#get_likes_for_status_message" do

    it "display given status message likes" do
	@status= FactoryGirl.create(:status_message,:author=>@user.person)
	FactoryGirl.create(:like,:author=> @user.person, :target=> @status)
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @user.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
	     :likes_count => "1"
        }.to_json

        get 'get_likes_for_status_message' ,{ 'access_token' => @at.token,'id' => @status.id, 'diaspora_handle' => @user.diaspora_handle }
        response.body.should include(@expected)
    end
  end

  describe "#get_number_of_comments_for_status_message" do

    it "display given status message comments" do
	@status= FactoryGirl.create(:status_message,:author=>@user.person)
        @comment = FactoryGirl.create(:comment,:post=>@status)
	FactoryGirl.create(:like,:author=> @user.person, :target=> @status)
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @user.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
	     :comments_count => "1"
        }.to_json

        get 'get_number_of_comments_for_status_message' ,{ 'access_token' => @at.token,'id' => @status.id, 'diaspora_handle' => @user.diaspora_handle }
        response.body.should include(@expected)
    end
  end

  describe "#create_status_message" do

    it "display ok status after creating new status" do
	@text = "Test Status"
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @user.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)

        get 'create_status_message' ,{ 'access_token' => @at.token,'text' => @text, 'diaspora_handle' => @user.diaspora_handle }
        response.response_code.should == 200
    end
  end

  describe "#delete_status_message" do

    it "display ok status after deleting given status" do
	@status= FactoryGirl.create(:status_message,:author=>@user.person)
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @user.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)

        get 'delete_status_message' ,{ 'access_token' => @at.token,'id' => @status.id, 'diaspora_handle' => @user.diaspora_handle }
        response.response_code.should == 200
    end
  end

end
