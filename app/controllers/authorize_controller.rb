class AuthorizeController < ApplicationController
  
  before_filter :authenticate_user!, :except => :verify
  
  def show

    @auth_token = params[:auth_token]
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
      access_req.save
      render :status => :ok, :text => "#{access_req.dev_handle} #{manifest.scopes} #{manifest.callback} verified"
    else
      render :text => "error"
    end
  end
  
end
