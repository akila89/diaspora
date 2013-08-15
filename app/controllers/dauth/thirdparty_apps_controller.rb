class Dauth::ThirdpartyAppsController < ApplicationController
  # GET /dauth/thirdparty_apps
  # GET /dauth/thirdparty_apps.json
  def index
    @dauth_thirdparty_apps = Dauth::ThirdpartyApp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dauth_thirdparty_apps }
    end
  end

  # GET /dauth/thirdparty_apps/1
  # GET /dauth/thirdparty_apps/1.json
  def show
    @app = Dauth::ThirdpartyApp.find(params[:id])
    @dev = Webfinger.new(@app.dev_handle).fetch

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dauth_thirdparty_app }
    end
  end

  # GET /dauth/thirdparty_apps/1/edit
  def edit
    @dauth_thirdparty_app = Dauth::ThirdpartyApp.find(params[:id])
  end

  # PUT /dauth/thirdparty_apps/1
  # PUT /dauth/thirdparty_apps/1.json
  def update
    @dauth_thirdparty_app = Dauth::ThirdpartyApp.find(params[:id])

    respond_to do |format|
      if @dauth_thirdparty_app.update_attributes(params[:dauth_thirdparty_app])
        format.html { redirect_to @dauth_thirdparty_app, notice: 'Thirdparty app was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dauth_thirdparty_app.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def revoke
    @dauth_thirdparty_apps = Dauth::ThirdpartyApp.all
    render :index
  end  

end
