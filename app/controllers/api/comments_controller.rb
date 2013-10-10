class Api::CommentsController < ApplicationController
  http_basic_authenticate_with :name => "sandaruwan1", :password => "sandaruwan1"

  skip_before_filter :authenticate_user!
  before_filter :fetch_user, :except => [:index, :create]

  def fetch_user
    @comment = Comment.find_by_id(params[:id])
  end

# Can retrieve all the comments in the current pod
  def index
    @comments = Comment.all
    respond_to do |format|
      format.json { render json: @comments }
      format.xml { render xml: @comments }
    end
  end

# Can retrieve comment specified by the id
  def show
    respond_to do |format|
      format.json { render json: @comment }
      format.xml { render xml: @comment }
    end
  end

# Can retrieve all comments posted by given user
def getGivenUserCommentList
    @user=User.find_by_id(params[:id]).diaspora_handle
    @commentList=Comment.all
    @comments_array = Array.new
       @commentList.each do |i| 
	 if i.diaspora_handle==@user
		@comments_array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @comments_array }
      format.xml { render xml: @comments_array }
    end
  end


# Can retrieve all comments posted by given user by handle
def getGivenUserCommentListByHandle
    @handle=params[:diaspora_handle]
    @commentList=Comment.all
    @comments_array = Array.new
       @commentList.each do |i| 
	 if i.diaspora_handle==@handle
		@comments_array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @comments_array }
      format.xml { render xml: @comments_array }
    end
  end

end


#API Requests:

#=> listing comments
#   url: http://localhost:3000/api/comments
#   method: GET


#=> Retrieving comment detail
#  url: http://localhost:3000/api/comments/:id 
#  method: GET


