class AuthorizeController < ApplicationController
  
  before_filter :authenticate_user!
  
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
  
end
