require "spec_helper"

describe Dauth::ThirdpartyAppsController do
  describe "routing" do

    it "routes to #index" do
      get("/dauth/thirdparty_apps").should route_to("dauth/thirdparty_apps#index")
    end

    it "routes to #new" do
      get("/dauth/thirdparty_apps/new").should route_to("dauth/thirdparty_apps#new")
    end

    it "routes to #show" do
      get("/dauth/thirdparty_apps/1").should route_to("dauth/thirdparty_apps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dauth/thirdparty_apps/1/edit").should route_to("dauth/thirdparty_apps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dauth/thirdparty_apps").should route_to("dauth/thirdparty_apps#create")
    end

    it "routes to #update" do
      put("/dauth/thirdparty_apps/1").should route_to("dauth/thirdparty_apps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dauth/thirdparty_apps/1").should route_to("dauth/thirdparty_apps#destroy", :id => "1")
    end

  end
end
