require 'spec_helper'

describe Dauth::AccessToken do
  before { 
  @accesstoken = Dauth::AccessToken.new(
      refresh_token: "refresh_token",
      secret: "access_secret",
      token: "access_token"
      )}
      
  subject { @accesstoken }
  
  it { should respond_to(:refresh_token) }
  it { should respond_to(:secret) }
  it { should respond_to(:token) }
  it { should be_valid }
  
  describe "when refresh token is not present" do
    before{ @accesstoken.refresh_token ="" }
    it {should_not be_valid }
  end
  
  #TODO refresh_token uniqueness validate
  
  describe "when secret is not present" do
    before{ @accesstoken.secret ="" }
    it {should_not be_valid }
  end
  
  describe "when access token is not present" do
    before{ @accesstoken.token ="" }
    it {should_not be_valid }
  end
end
