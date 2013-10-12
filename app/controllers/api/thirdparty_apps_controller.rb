class Api::ThirdpartyAppsController < ApplicationController
  http_basic_authenticate_with :name => "sandaruwan1", :password => "sandaruwan1"

  skip_before_filter :authenticate_user!
  before_filter :fetch_user, :except => [:index, :create]

  def fetch_user
    @app = Dauth::ThirdpartyApp.find(params[:id])
  end

  # Can retrieve third party app list
  def index
    @appList = Dauth::ThirdpartyApp.all
    respond_to do |format|
      format.json { render json: @appList }
      format.xml { render xml: @appList }
    end
  end

  # Can retrieve app specified by the id
  def show
    respond_to do |format|
      format.json { render json: @app }
      format.xml { render xml: @app }
    end
  end

  # Can retrieve scopes related to an app
  def getAppScopes
    @appId=Dauth::ThirdpartyApp.find(params[:id]).app_id
    @apps=Dauth::RefreshToken.all
    @app
    @apps.each do |i|
	 if i.app_id==@appId
		@app=i
	 end
    end
    @scopes=@app.scopes
    respond_to do |format|
      format.json { render json: @scopes }
      format.xml { render xml: @scopes }
    end
  end

end

