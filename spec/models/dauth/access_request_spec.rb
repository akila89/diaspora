require 'spec_helper'

describe Dauth::AccessRequest do
  before { 
    @accessrequest = Dauth::AccessRequest.new(
      auth_token: "asdfghjkl", 
      callback: "http://abcd.com", 
      dev_handle: "dev@pod.com",
      scopes: "name yes"
      )}
      
  subject { @accessrequest }
  
  it { should respond_to(:auth_token) }
  it { should respond_to(:callback) }
  it { should respond_to(:dev_handle) }
  it { should respond_to(:scopes) }
  it { should be_valid }
  
  describe "when authentication token is not present" do
    before{ @accessrequest.auth_token ="" }
    it {should_not be_valid }
  end
  
  #TODO auth_token uniqueness validate
  
  describe "when callback url is not present" do
    before{ @accessrequest.callback ="" }
    it {should_not be_valid }
  end
  
  describe "when scopes is not present" do
    before{ @accessrequest.scopes ="" }
    it {should_not be_valid }
  end
  
end
