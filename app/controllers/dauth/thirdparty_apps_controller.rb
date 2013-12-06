class Dauth::ThirdpartyAppsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @dauth_thirdparty_apps = current_user.thirdparty_apps
  end

  def show
    @app = current_user.thirdparty_apps.find(params[:id])
    @dev = Webfinger.new(@app.dev_handle).fetch
  end

  def edit
    @dauth_thirdparty_app = Dauth::ThirdpartyApp.find(params[:id])
  end

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
  
  def destroy
    @dauth_thirdparty_apps = current_user.thirdparty_apps
    render :index
  end  

end
