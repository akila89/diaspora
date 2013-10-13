class AuthorizeController < ApplicationController
  include Authenticator
  before_filter :authenticate_user!, :except => :verify
  
  def show

    @auth_token = params[:auth_token]
    Rails.logger.info("Content of the authentication token #{@auth_token}")
    
    #TODO user mismatch
    #if not  <app user>== current_user.diaspora_handle
    #  Rails.logger.info("Users miss match - #{current_user.diaspora_handle}, <app user>")
    #  render :status => :bad_request, :json => {:error => 102} #usermismatch
    #end
    
    @access_request = Dauth::AccessRequest.find_by_auth_token(@auth_token)
    
    if not @access_request.nil?
      @dev = Webfinger.new(@access_request.dev_handle).fetch   #developer profile details
      @scopes_ar = @access_request.scopes 
      Rails.logger.info("Content of the scopes #{@access_request.scopes}")
    else
      Rails.logger.info("Authentication token #{@auth_token} is illegal")
      render :status => :bad_request, :json => {:error => 100} #illegal authentication token 
    end
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
    @person = current_user.person
    #get scopes
    @scopes = Array.new
    params[:scopes].each do |k,v|
      @scopes.push(k) if v=="1"
    end
    @authorize.scopes = @scopes
    @authorize.app_id = params[:app_id]
    @authorize.user_guid = current_user.guid
     
    if @authorize.save
      Rails.logger.info("Generated refresh token - #{@authorize.token}")
      
      #save new third party app details
      token = params[:token]
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
      
      sendRefreshToken @authorize, params[:callback], @person.diaspora_handle  #Send a HTTP request to App with refresh token
      redirect_to "http://localhost:8083/SearchApp/user?diaspora_id=#{@person.diaspora_handle}"
    else
      Rails.logger.info("Unable to generate refresh token")
      render :status => :bad_request, :json => {:error => 101} #Error generating refresh token
    end

  end

  def access_token
    @refresh_token= params[:refresh_token]

    if (Dauth::RefreshToken.find_by_token(@refresh_token).nil?)
      Rails.logger.info("refresh token #{@refresh_token} is illegal")
      render :status => :bad_request, :json => {:error => "200"} #Illegal Refresh Token    
    else
      if not Dauth::AccessToken.find_by_refresh_token(@refresh_token).nil?
        @access_token = Dauth::AccessToken.find_by_refresh_token(@refresh_token)
        if (@access_token.expire?)
          Rails.logger.info("Access token #{@access_token} is expired")
          @new_access_token= Dauth::AccessToken.new
          @new_access_token.refresh_token=@refresh_token
          @new_access_token.save
          Rails.logger.info("New access token - #{@new_access_token}")
          render :status => :ok, :json => {:access_token => "#{@new_access_token.token}}"}
        else
          Rails.logger.info("Access token - #{@access_token}")
          render :status => :ok, :json => {:access_token => "#{@access_token.token}}"} #send current access token
        end
      else
        @new_access_token= Dauth::AccessToken.new
        @new_access_token.refresh_token=@refresh_token
        @new_access_token.save
        Rails.logger.info("New access token - #{@new_access_token}")
        render :status => :ok, :json => {:access_token => "#{@new_access_token.token}}"}
      end
    end
  end

end
