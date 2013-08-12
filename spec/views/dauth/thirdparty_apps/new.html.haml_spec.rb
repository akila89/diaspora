require 'spec_helper'

describe "dauth/thirdparty_apps/new" do
  before(:each) do
    assign(:dauth_thirdparty_app, stub_model(Dauth::ThirdpartyApp,
      :app_id => "MyString",
      :name => "MyString",
      :description => "MyString",
      :homepage_url => "MyString",
      :dev_handle => "MyString"
    ).as_new_record)
  end

  it "renders new dauth_thirdparty_app form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", dauth_thirdparty_apps_path, "post" do
      assert_select "input#dauth_thirdparty_app_app_id[name=?]", "dauth_thirdparty_app[app_id]"
      assert_select "input#dauth_thirdparty_app_name[name=?]", "dauth_thirdparty_app[name]"
      assert_select "input#dauth_thirdparty_app_description[name=?]", "dauth_thirdparty_app[description]"
      assert_select "input#dauth_thirdparty_app_homepage_url[name=?]", "dauth_thirdparty_app[homepage_url]"
      assert_select "input#dauth_thirdparty_app_dev_handle[name=?]", "dauth_thirdparty_app[dev_handle]"
    end
  end
end
