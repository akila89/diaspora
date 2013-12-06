class Api::ApiController < ApplicationController

  before_filter :validate_access_token, :validate_user

  def validate_access_token
    @token = params[:access_token]
    @access_token = Dauth::AccessToken.find_by_token(@token)

    if @access_token.nil?
      Rails.logger.info("Access token #{@token} is illegal")
      render :status => :bad_request, :json => {:error => "300"} #Illegal Access Token
    else
      if @access_token.expire?
        Rails.logger.info("Access token #{@token} is expired")
        render :status => :bad_request, :json => {:error => "301"} #Access Token is expired
      end
    end
  end
  
  # validate user
  def validate_user
    @diaspora_handle=params[:diaspora_handle]
    @access_token_tuple=Dauth::AccessToken.find_by_token(params[:access_token])
    @handle=Dauth::RefreshToken.find_by_token(@access_token_tuple.refresh_token).user.diaspora_handle
    if @handle!=@diaspora_handle
	    render :status => :bad_request, :json => {:error => "403"} #Accessing with an unauthorized access token
    end
  end

  # Profile related user permissions
  
  def require_profile_read_permision
    @scopes = get_scopes
    
    unless @scopes.include?('profile_read')
      Rails.logger.info("User do not have profile read permissions")
      render :status => :bad_request, :json => {:error => "310"} #No profile read permissions
    end
  end
  
  def require_profile_write_permision
    @scopes = get_scopes
    
    unless @scopes.include?('profile_write')
      Rails.logger.info("User do not have profile write permissions")
      render :status => :bad_request, :json => {:error => "311"} #No profile write permissions
    end
  end
  
  def require_profile_delete_permision
    @scopes = get_scopes
    
    unless @scopes.include?('profile_delete')
      Rails.logger.info("User do not have profile delete permissions")
      render :status => :bad_request, :json => {:error => "312"} #No profile delete permissions
    end
  end
  
  # Comments related user permissions
  
  def require_comment_read_permision
    @scopes = get_scopes
    
    unless @scopes.include?('comment_read')
      Rails.logger.info("User do not have comment read permissions")
      render :status => :bad_request, :json => {:error => "320"} #No comment read permissions
    end
  end
  
  def require_comment_write_permision
    @scopes = get_scopes
    
    unless @scopes.include?('comment_write')
      Rails.logger.info("User do not have comment write permissions")
      render :status => :bad_request, :json => {:error => "321"} #No comment write permissions
    end
  end
  
  def require_comment_delete_permision
    @scopes = get_scopes
    
    unless @scopes.include?('comment_delete')
      Rails.logger.info("User do not have comment delete permissions")
      render :status => :bad_request, :json => {:error => "322"} #No comment delete permissions
    end
  end
  
  # Post related user permissions
  
  def require_post_read_permision
    @scopes = get_scopes
    
    unless @scopes.include?('post_read')
      Rails.logger.info("User do not have post read permissions")
      render :status => :bad_request, :json => {:error => "330"} #No post read permissions
    end
  end
  
  def require_post_write_permision
    @scopes = get_scopes
    
    unless @scopes.include?('post_write')
      Rails.logger.info("User do not have post write permissions")
      render :status => :bad_request, :json => {:error => "331"} #No post write permissions
    end
  end
  
  def require_post_delete_permision
    @scopes = get_scopes
    
    unless @scopes.include?('post_delete')
      Rails.logger.info("User do not have post delete permissions")
      render :status => :bad_request, :json => {:error => "332"} #No post delete permissions
    end
  end
  
  #get scopes relevant to user
  def get_scopes
    @token = params[:access_token]
    @refresh_token = Dauth::AccessToken.find_by_token(@token).refresh_token
    @scopes = Dauth::RefreshToken.find_by_token(@refresh_token).scopes
    
    return @scopes
  end


end
