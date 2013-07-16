class Api::UsersController < ApplicationController
  http_basic_authenticate_with :name => "sandaruwan1", :password => "sandaruwan1"

  skip_before_filter :authenticate_user!
  before_filter :fetch_user, :except => [:index, :create]

 def fetch_user
    @user = User.find_by_id(params[:id])
  end

  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: @users }
      format.xml { render xml: @users }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @user }
      format.xml { render xml: @user }
    end
  end

  def diaspora_handle
    respond_to do |format|
      format.json { render json: "sanda" }
      format.xml { render xml: @user }
    end
  end
end


#API Requests:

#=> listing users
#   url: http://localhost:3000/api/users
#   method: GET


#=> Retrieving User detail
#  url: http://localhost:3000/api/users/:id 
#  method: GET



