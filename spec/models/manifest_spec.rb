require 'spec_helper'

describe Manifest do
  describe "validation" do
    describe "of object from fractory" do
      it "must be ok" do
        FactoryGirl.build(:manifest).should be_valid
      end
    end

    describe "of app_name" do
      it "requires presence" do
        FactoryGirl.build(:manifest, app_name: "").should_not be_valid
      end
    end

    describe "of app_description" do
      it "should not be longer than 500 characters" do
        FactoryGirl.build(:manifest, app_description: "a"*505).should_not be_valid
      end
    end

    describe "of callback_url" do
      it "requires presence" do
        FactoryGirl.build(:manifest, callback_url: "").should_not be_valid
      end

      it "requires format of a valid url" do
        FactoryGirl.build(:manifest, callback_url: "not a valid url").should_not be_valid
      end
    end

    describe "of redirect_url" do
      it "requires presence" do
        FactoryGirl.build(:manifest, redirect_url: "").should_not be_valid
      end

      it "requires format of a valid url" do
        FactoryGirl.build(:manifest, redirect_url: "not a valid url").should_not be_valid
      end
    end

  end

  describe "get manifest hash" do
    it "should return a hash correctly describing the manifest" do
      test_params = {
          :dev_id => "test@example.net",
          :app_id => "test_app_id",
          :app_name => "A Test App",
          :app_version => "1.0",
          :app_description => "This is a description of a test app",
          :callback_url => "http://examplecallback.com",
          :redirect_url => "http://examplecallback.com",
          :scopes => ["post_write", "comment_write", "friend_list_read"]
      }
 
      test_manifest = Manifest.new(test_params)

      expected_hash = {
          :access => ["post_write", "comment_write", "friend_list_read"],
          :app_details => { :name=>"A Test App", :id=>"test_app_id", :description=>"This is a description of a test app", :version=>"1.0" },
          :callback => "http://examplecallback.com",
          :dev_id => "test@example.net",
          :redirect => "http://examplecallback.com",
          :manifest_version => "1.0"
      }

      test_manifest.get_manifest_hash.should == expected_hash
    end
  end  
end
