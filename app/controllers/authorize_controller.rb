class AuthorizeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show

    @dev_handle = 'dev@pod.com'
    @dev_email = 'dev@mail.com'
    @app_name = 'Sample App'
    @app_description = 'Sample App discription'
    @app_version = 'v1.0'
    
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
  
  def verify
    signed_manifest= params[:signed_manifest]
    Rails.logger.info("content of the signed manifest #{signed_manifest}")

    res = Manifest.new.verify(signed_manifest)

    if res
      Faraday.post(res[callbacks][success])
    end
  end
   
  private
  
  def generate_refresh_token
    @refresh_token = (Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end
  
end
