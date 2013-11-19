class Api::CommentsController < Api::ApiController

  before_filter :require_comment_read_permision, :only => [:get_given_user_comment_list,
                                                           :get_given_user_comment_list_by_handle,
                                                           :get_likes_count,
							   :index,
							   :show,
							   :create_comment]
  #before_filter :require_comment_delete_permision, :only => [:deleteComment]

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
def get_given_user_comment_list
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @commentList=Comment.all
    @comments_array = Array.new
       @commentList.each do |i| 
	 if i.diaspora_handle==params[:diaspora_handle]
	        @comment = {author_id: i.author_id.nil? ? "":i.author_id, commentable_id: i.commentable_id.nil? ? "":i.commentable_id, id: i.id.nil? ? "":i.id, likes_count: i.likes_count.nil? ? "":i.likes_count, text: i.text.nil? ? "":i.text}
        	@comments_array.push @comment	
	 end  
       end
    respond_to do |format|
      format.json { render json: @comments_array }
      format.xml { render xml: @comments_array }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve likes count for a comment
  def get_likes_count
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @comment=Comment.find_by_id(params[:id])
    if @person && @comment
      if @person.diaspora_handle==@comment.diaspora_handle
	        @likes_count = {likes_count: @comment.likes_count.nil? ? "": @comment.likes_count}.to_json	
      respond_to do |format|
        format.json { render json: @likes_count }
        format.xml { render xml: @likes_count }
      end
      else
          respond_to do |format|
            format.json { render :status => :bad_request, :json => {:error => 501}}  # incompatible data
          end
      end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Create a comment for a specified post id
  def create_comment
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @user=@person.owner
    post = @user.find_visible_shareable_by_id(Post, params[:post_id])
    if @person && post
    @comment = @user.comment!(post, params[:text]) if post
      if @comment
        respond_to do |format|
          format.json{ render :json => CommentPresenter.new(@comment)}
        end
      else
        render :nothing => true
      end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Delete a comment for a specified comment id
 def delete_comment
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @comment=Comment.find_by_id(params[:id])
    if @person && @comment
    @user=@person.owner
    @comment = Comment.find(params[:id])
    if @user.owns?(@comment) || @user.owns?(@comment.parent)
      @user.retract(@comment)
      respond_to do |format|
        format.json { render :nothing => true }
      end
    else
          respond_to do |format|
            format.json { render :status => :bad_request, :json => {:error => 501}}  # incompatible data
          end
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
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



