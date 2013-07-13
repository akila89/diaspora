require 'spec_helper'

describe Dauth::AllowedApps do
  before { 
    @allowdapps = Dauth::AllowedApps.new(
      app_home_page_url: "www.testapp.com/home",
      app_id: "01",
      app_name: "testapp",
      callback: "www.callbacktest.com",
      dev_handle: "dev@pod.com",
      discription: "test app description",
      manifest: "test manifest"
      )}
      
  subject { @allowdapps }
  
  it { should respond_to(:app_home_page_url) }
  it { should respond_to(:app_id) }
  it { should respond_to(:app_name) }
  it { should respond_to(:callback) }
  it { should respond_to(:dev_handle) }
  it { should respond_to(:discription) }
  it { should respond_to(:manifest) }
  it { should be_valid }
  
  describe "when app id is not present" do
    before{ @allowdapps.app_id ="" }
    it {should_not be_valid }
  end
  
  #TODO app_id uniqueness validate
  
  describe "when manifest is not present" do
    before{ @allowdapps.manifest ="" }
    it {should_not be_valid }
  end
  
  describe "when app home page url is not present" do
    before{ @allowdapps.app_home_page_url ="" }
    it {should_not be_valid }
  end
end
