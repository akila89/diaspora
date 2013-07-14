class AuthorizeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show

    @dev_handle = 'dev@pod.com'
    @dev_email = 'dev@mail.com'
    @app_name = 'Sample App'
    @app_description = 'Sample App discription'
    @app_version = 'v1.0'
    @scopes_ar = ["profile_read","gasdfasdfa"]
    
  end
  
  def update
    @authorize = Dauth::RefreshToken.new
    
    #get scopes
    @scopes = Array.new
    params[:scopes].each do |k,v|
      if k=="scopes_ar"
        @sar = v.gsub!(/[\[\"\]]/,'').split(',')
        @scopes.concat(@sar)
      end
      @scopes<<k if v=="1" 
    end
    
    @authorize.scopes = @scopes
    @authorize.token = generate_refresh_token
    @authorize.app_id = "01"             #TODO get real app_id
    @authorize.user_guid = "sdafdsfad"   #TODO redirect user_guid
    @authorize.secret = "secret"         #TODO redirect secrets
    
    if @authorize.save
      flash[:notice] = "#{@scopes.to_s} refresh token - #{generate_refresh_token}"    
    else 
      flash[:notice] = "#{@scopes.to_s} Authentication Fail" 
    end
    redirect_to action: 'show'                       #TODO redirect back to callback URL
  end
   
  private
  
  def generate_refresh_token
    @refresh_token = (Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end
  
end
