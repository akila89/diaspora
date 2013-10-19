class Api::ThirdpartyAppsController < Api::ApiController

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
end

