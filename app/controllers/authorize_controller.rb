class AuthorizeController < ApplicationController
  include Authenticator
  before_filter :authenticate_user!, :except => :verify
  
  def show

    @dev_handle = 'dev@pod.com'
    @dev_email = 'dev@mail.com'
    @app_name = 'Sample App'
    @app_description = 'Sample App discription'
    @app_version = 'v1.0'
    
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
      manifestVerified access_req
      render :status => :ok, :text => "#{access_req.dev_handle} #{manifest.scopes} #{manifest.callback} verified"
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
    @authorize.token = generate_refresh_token
    @authorize.app_id = "01"             #TODO get real app_id
    @authorize.user_guid = "sdafdsfad"   #TODO redirect user_guid
    @authorize.secret = "secret"         #TODO redirect secrets
    
    if @authorize.save
      flash[:notice] = "refresh token - #{generate_refresh_token}"    
    else 
      flash[:notice] = "Authentication Fail" 
    end
    redirect_to action: 'show'                       #TODO redirect back to callback URL
  end
   
  private
  
  def generate_refresh_token
    @refresh_token = (Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end
  
end
