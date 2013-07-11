class AuthorizeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    
  end
  
  def update
    flash[:notice] = "refresh token - #{generate_refresh_token}"
    render :show
  end
   
  private
  
  def generate_refresh_token
    @refresh_token = (Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end
  
end
