require 'spec_helper'

describe ManifestController do

  describe "GET 'sign'" do
    it "returns http success" do
      get 'sign'
      response.should be_success
    end
  end

  describe "GET 'verify'" do
    it "returns http success" do
      get 'verify'
      response.should be_success
    end
  end

end
