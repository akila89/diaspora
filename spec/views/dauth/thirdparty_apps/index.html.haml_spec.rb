require 'spec_helper'

describe "dauth/thirdparty_apps/index" do
  before(:each) do
    assign(:dauth_thirdparty_apps, [
      stub_model(Dauth::ThirdpartyApp,
        :app_id => "App",
        :name => "Name",
        :description => "Description",
        :homepage_url => "Homepage Url",
        :dev_handle => "Dev Handle"
      ),
      stub_model(Dauth::ThirdpartyApp,
        :app_id => "App",
        :name => "Name",
        :description => "Description",
        :homepage_url => "Homepage Url",
        :dev_handle => "Dev Handle"
      )
    ])
  end

  it "renders a list of dauth/thirdparty_apps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "App".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Homepage Url".to_s, :count => 2
    assert_select "tr>td", :text => "Dev Handle".to_s, :count => 2
  end
end
