class Api::CommentsController < Api::ApiController

  before_filter :require_comment_read_permision, :only => [:get_given_user_comment_list,
                                                           :get_likes_count,
							                                             ]

  before_filter :require_comment_write_permision, :only => [:create_comment
                                                            ]

  before_filter :require_comment_delete_permision, :only => [:delete_comment
                                                             ]


# Retrieve all comments posted by a given user

  def get_given_user_comment_list
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if person
      commentList=Comment.all
      comments_array = Array.new
      commentList.each do |i| 
        if i.diaspora_handle==params[:diaspora_handle]

          comment = {author_id: i.author_id.nil? ? "":i.author_id, commentable_id: i.commentable_id.nil? ? "":i.commentable_id, id: i.id.nil? ? "":i.id, likes_count: i.likes_count.nil? ? "":i.likes_count, text: i.text.nil? ? "":i.text}

          comments_array.push comment	
	      end  
      end
      render :status => :ok, :json => {:user_comment_list => comments_array}	# Successfully render the Json response
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Retrieve likes count for a comment

  def get_likes_count
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    comment=Comment.find_by_id(params[:id])
    if person && comment
      if person.diaspora_handle==comment.diaspora_handle
	      likes_count = {likes_count: comment.likes_count.nil? ? "": comment.likes_count.to_s()}	
	      render :status => :ok, :json => {:likes_count => likes_count}	# Successfully render the Json response
      else
        render :status => :unauthorized, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Create a comment for a specified post id

  def create_comment
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    user=person.owner
    post = user.find_visible_shareable_by_id(Post, params[:post_id])
    if person && post
      comment = user.comment!(post, params[:text]) if post
      if comment
	      render :status => :ok, :json => {:user_comment_list => CommentPresenter.new(comment)}	# Successfully created the comment
      else
        render :status => :unsuported_type, :json => {:error => "402"}	# Accessing with invalid param values
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Delete a comment for a specified comment id

  def delete_comment
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    comment=Comment.find_by_id(params[:id])
    if person && comment
      user=person.owner
      comment = Comment.find(params[:id])
      if user.owns?(comment) || user.owns?(comment.parent)
        user.retract(comment)
	      render :nothing => true	# Successfully deleted the comment
      else
	      render :status => :unauthorized, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

end


