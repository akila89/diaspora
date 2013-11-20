require 'spec_helper'

describe Api::StatusMessagesController do

  before do
    @user = alice
    sign_in :user, @user
    @controller.stub(:current_user).and_return(@user)
  end

  describe "#get_given_user_status_list" do

    it "display given user status list" do
	@status= FactoryGirl.create(:post,{:author_id=>@user.id,:text=>"saman"})
        @rt   = FactoryGirl.create(:refresh_token, :user_guid=> @status.guid)
        @at   = FactoryGirl.create(:access_token, :refresh_token => @rt.token)
	        @expected={
            :author_id      		=> @status.author_id,
            :comments_count       	=> @status.comments_count,
            :diaspora_handle_of_creator => "",
            :status_id        		=> @status.id,
            :likes_count       		=> @status.likes_count,
            :text          		=> @status.text
        }.to_json

        get 'get_given_user_status_list' ,{ 'access_token' => @at.token, 'diaspora_handle' => 'alice@localhost:9887' }
        response.body.should include(@expected)
    end
  end

end
