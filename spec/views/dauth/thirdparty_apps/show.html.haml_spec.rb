require 'spec_helper'

describe "dauth/thirdparty_apps/show" do
  before(:each) do
    @dauth_thirdparty_app = assign(:dauth_thirdparty_app, stub_model(Dauth::ThirdpartyApp,
      :app_id => "App",
      :name => "Name",
      :description => "Description",
      :homepage_url => "Homepage Url",
      :dev_handle => "Dev Handle"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/App/)
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/Homepage Url/)
    rendered.should match(/Dev Handle/)
  end
end
