class Api::CommentsController < Api::ApiController

  before_filter :require_comment_read_permision, :only => [:getGivenUserCommentList,
                                                           :getGivenUserCommentListByHandle,
                                                           :getLikesCount,
							   :index,
							   :show,
							   :createComment]
  before_filter :require_comment_delete_permision, :only => [:deleteComment]

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

# Can retrieve likes count for a comment
  def getLikesCount
    @likes_count=Comment.find_by_id(params[:id]).likes_count
    respond_to do |format|
      format.json { render json: @likes_count }
      format.xml { render xml: @likes_count }
    end
  end

# Create a comment for a specified post id
  def createComment
    post = current_user.find_visible_shareable_by_id(Post, params[:post_id])
    @comment = current_user.comment!(post, params[:text]) if post

    if @comment
      respond_to do |format|
        format.json{ render :json => CommentPresenter.new(@comment)}
      end
    else
      render :nothing => true
    end
  end

# Delete a comment for a specified comment id
 def deleteComment
    @comment = Comment.find(params[:id])
    if current_user.owns?(@comment) || current_user.owns?(@comment.parent)
      current_user.retract(@comment)
      respond_to do |format|
        format.json { render :nothing => true }
      end
    else
      respond_to do |format|
        format.json {render :nothing => true}
      end
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



