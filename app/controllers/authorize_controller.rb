class AuthorizeController < ApplicationController
  include Authenticator
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
    Rails.logger.info(@access_request.scopes)

  end

  def verify
    signed_manifest= params[:signed_manifest]

    if not signed_manifest
      render :status => :bad_request, :json => {:error => 000}
    end

    Rails.logger.info("content of the signed manifest #{signed_manifest}")
    manifest = Manifest.new.bySignedJWT signed_manifest

    if not manifest
      render :status => :bad_request, :json => {:error => 001}

    end

    res = manifest.verify

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
      render :status => :ok, :json => {:auth_token => "#{access_req.auth_token}"}
    else
      render :status => :bad_request, :json => {:error => 002}
    end
  end

  def update
    @authorize = Dauth::RefreshToken.new

    #get scopes
    @scopes = Array.new
    params[:scopes].each do |k,v|
      @scopes.push(k) if v=="1"
    end

    @authorize.scopes = @scopes
    @authorize.app_id = params[:scopes][:app_id]
    @authorize.user_guid = current_user.guid

    if @authorize.save
      #flash[:notice] = "#{@scopes.to_s} Authentication Success"
      sendRefreshToken @authorize, params[:scopes][:callback]
      #TODO show app user page
      render :status => :ok, :json => {:ref_token => "#{@authorize.token}}"}
    else
    #flash[:notice] = "#{@scopes.to_s} Authentication Fail"
      render :text => "error"
    end
    token = params[:scopes][:token]
    access_req = Dauth::AccessRequest.find_by_auth_token(token)
    app = Dauth::ThirdpartyApp.find_by_app_id(access_req.app_id)
    if not app
      app = Dauth::ThirdpartyApp.new
    app.app_id = access_req.app_id
    app.name = access_req.app_name
    app.description = access_req.app_description
    app.dev_handle = access_req.dev_handle
    app.save
    end
  end

  def access_token
    @refresh_token= param[:refresh_token]

    if (Dauth::RefreshToken.find_by_token(@refresh_token).nil?)
      Rails.logger.info("refresh token #{@refresh_token} is illegal")
      render :status => "bad request", :json => {:error => "100"} #Illegal Refresh Token
    else
      if not Dauth::AccessToken.find_by_refresh_token(@refresh_token).nil?
        @access_token = Dauth::AccessToken.find_by_refresh_token(@refresh_token)
        if (@access_token.expire?)
          Rails.logger.info("access token #{@access_token} is expired")
          #send new access token
          @new_access_token= Dauth::AccessToken.new
          @new_access_token.refresh_token=@refresh_token
          @new_access_token.save
          render :status => :ok, :json => {:access_token => "#{@new_access_token.token}}"}
        else
          render :status => :ok, :json => {:access_token => "#{@access_token.token}}"}
        end
      else
      #send new access token
        @new_access_token= Dauth::AccessToken.new
        @new_access_token.refresh_token=@refresh_token
        @new_access_token.save
        render :status => :ok, :json => {:access_token => "#{@new_access_token.token}}"}
      end
    end
  end

end
