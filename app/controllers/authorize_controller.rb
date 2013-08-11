class AuthorizeController < ApplicationController
  include Authenticator
  #before_filter :authenticate_user!, :except => :verify

  def show
    
    @auth_token = params[:auth_token] #"10fa22d536828ee7b3d22833971e5068" test 
    Rails.logger.info("content of the authentication token #{@auth_token}")
    
    @access_request = Dauth::AccessRequest.find_by_auth_token(@auth_token)
    @dev_handle = @access_request.dev_handle
    
    @dev = Webfinger.new(@dev_handle).fetch
    
    @app_id = @access_request.app_id
    @callback = @access_request.callback
    @app_name = @access_request.app_name
    @app_description = @access_request.app_description
    @app_version = @access_request.app_version
    @scopes_ar = @access_request.scopes
    
  end

  def verify
    signed_manifest= params[:signed_manifest]
    Rails.logger.info("content of the signed manifest #{signed_manifest}")
    manifest = Manifest.new.bySignedJWT signed_manifest
    if manifest
      res = manifest.verify
    end
    if res
      access_req = Dauth::AccessRequest.new
      access_req.dev_handle = manifest.dev_id
      access_req.callback = manifest.callback
      access_req.scopes = manifest.scopes
      access_req.app_id = manifest.app_id
      access_req.app_name = manifest.app_name
      access_req.app_description = manifest.app_description
      access_req.app_version = manifest.app_version
      access_req.save
      #manifestVerified access_req

      render :status => :ok, :json => {:auth_token => "#{access_req.auth_token}"}
    else
      render :text => "error"
    end
  end

  def update
    @authorize = Dauth::RefreshToken.new

    #get scopes
    @scopes = Array.new
    params[:scopes].each do |k,v|
      @scopes<<k if v=="1" 
    end
    
    @authorize.scopes = @scopes
    @authorize.app_id = params[:scopes][:app_id]
    @authorize.user_guid = current_user.guid
    
    if @authorize.save
      flash[:notice] = "#{@scopes.to_s} Authentication Success"
      #sendRefreshToken @authorize, params[:scopes][:callback]   
      render :status => :ok, :json => {:ref_token => "#{@authorize.token}}"}  
      
    else 
      flash[:notice] = "#{@scopes.to_s} Authentication Fail"
      render :text => "error"
    end
  end
  
  def access_token
    @refresh_token= param[:refresh_token]
    
    
  end
  
end
