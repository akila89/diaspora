class AuthorizeController < ApplicationController
  include Authenticator
  before_filter :authenticate_user!, :except => [:verify, :access_token]
  ALL_SCOPES = ["post_write", "post_read", "post_delete", "comment_write", "comment_read", "profile_read", "friend_list_read"]
  
  def show

    @auth_token = params[:auth_token]
    @diaspora_han = params[:diaspora_handle]
    Rails.logger.info("Content of the authentication token #{@auth_token}")
    
    #TODO user mismatch
    #if not  <app user>== current_user.diaspora_handle
    #  Rails.logger.info("Users miss match - #{current_user.diaspora_handle}, <app user>")
    #  render :status => :bad_request, :json => {:error => 102} #usermismatch
    #end
    
    @access_request = Dauth::AccessRequest.find_by_auth_token(@auth_token)
    
    if @access_request
      @dev = Webfinger.new(@access_request.dev_handle).fetch   #developer profile details
      @scopes = ALL_SCOPES - @access_request.scopes
      Rails.logger.info("Content of the scopes #{@access_request.scopes}")
    else
      Rails.logger.info("Authentication token #{@auth_token} is illegal")
      render :status => :bad_request, :json => {:error => 100} #illegal authentication token 
    end
  end

  def verify
    signed_manifest= params[:signed_manifest]

    if not signed_manifest
      render :status => :bad_request, :json => {:error => "000"}
      return
    end

    Rails.logger.info("content of the signed manifest #{signed_manifest}")
    manifest = Manifest.by_signed_jwt signed_manifest

    if not manifest
      render :status => :bad_request, :json => {:error => "001"}
      return
    end

    res = manifest.verify

    if res
      access_req = Dauth::AccessRequest.new
      access_req.dev_handle = manifest.dev_id
      access_req.callback = manifest.callback_url
      access_req.scopes = manifest.scopes
      access_req.app_id = manifest.app_id
      access_req.app_name = manifest.app_name
      access_req.app_description = manifest.app_description
      access_req.app_version = manifest.app_version
      access_req.redirect_url = manifest.redirect_url
      access_req.save
      render :status => :ok, :json => {:auth_token => "#{access_req.auth_token}"}
    else
      render :status => :bad_request, :json => {:error => "002"}
    end
  end

  def update
    if params[:commit] == 'Deny' # If user denies app 
      redirect_to stream_path
      return
    end  

    access_request = Dauth::AccessRequest.where(:auth_token => params[:authorize_token])[0]
    refresh_token = current_user.refresh_tokens.find_or_create_by_app_id(access_request.app_id)
    if params[:scopes]
      refresh_token.scopes = access_request.scopes + params[:scopes]
    else
      refresh_token.scopes = access_request.scopes
    end

    if refresh_token.save
      app = current_user.thirdparty_apps.find_or_create_by_app_id(access_request.app_id)
      app.app_id = access_request.app_id
      app.name = access_request.app_name
      app.description = access_request.app_description
      app.dev_handle = access_request.dev_handle
      app.save
    else
      Rails.logger.info("Unable to generate refresh token")
      render :status => :bad_request, :json => {:error => "101"} #Error generating refresh token
      return
    end
    redirect_to access_request.redirect_url
	  sendRefreshToken refresh_token, access_request.callback, current_user.diaspora_handle  #Send a HTTP request to App with refresh token
  end

  def access_token
    @refresh_token = Dauth::RefreshToken.find_by_token params[:refresh_token]

    if not @refresh_token
      Rails.logger.info("refresh token #{@refresh_token} is illegal")
      render :status => :bad_request, :json => {:error => "200"} #Illegal Refresh Token   
    else
      if @refresh_token.access_tokens.last
        @access_token = @refresh_token.access_tokens.last
        if @access_token.expire?
          Rails.logger.info("Access token #{@access_token} is expired")
          @new_access_token= @refresh_token.access_tokens.new
          @new_access_token.save
          Rails.logger.info("New access token - #{@new_access_token}")
          render :status => :ok, :json => {:access_token => "#{@new_access_token.token}"}
        else
          Rails.logger.info("Access token - #{@access_token}")
          render :status => :ok, :json => {:access_token => "#{@access_token.token}"} #send current access token
        end
      else
        @new_access_token= @refresh_token.access_tokens.new
        @new_access_token.save
        Rails.logger.info("New access token - #{@new_access_token}")
        render :status => :ok, :json => {:access_token => "#{@new_access_token.token}"}
      end
    end
  end

end
