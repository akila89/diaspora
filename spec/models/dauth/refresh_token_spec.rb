require 'spec_helper'

describe Dauth::RefreshToken do
  before { 
    @refreshtoken = Dauth::RefreshToken.new(
      app_id: "01",
      scopes: "test app scopes", 
      secret: "test app secret", 
      token: "refresh token", 
      user_guid: "user01"
      )}
      
  subject { @refreshtoken }
  
  it { should respond_to(:app_id) }
  it { should respond_to(:scopes) }
  it { should respond_to(:secret) }
  it { should respond_to(:token) }
  it { should respond_to(:user_guid) }
  it { should be_valid }
  
  describe "when refresh token is not present" do
    before{ @refreshtoken.app_id ="" }
    it {should_not be_valid }
  end
  
  #TODO refresh token uniqueness validate
  
  describe "when app id is not present" do
    before{ @refreshtoken.app_id ="" }
    it {should_not be_valid }
  end
  
  describe "when scopes is not present" do
    before{ @refreshtoken.scopes ="" }
    it {should_not be_valid }
  end
  
  describe "when secret is not present" do
    before{ @refreshtoken.secret ="" }
    it {should_not be_valid }
  end
  
  describe "when user guid is not present" do
    before{ @refreshtoken.user_guid ="" }
    it {should_not be_valid }
  end
end
