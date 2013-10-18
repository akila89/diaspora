class Api::ApiController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_access_token

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

end
