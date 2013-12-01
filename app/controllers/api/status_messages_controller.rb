class Api::StatusMessagesController < Api::ApiController

  before_filter :require_post_read_permision, :only => [:get_given_user_status_list,
                                                        :get_comments_for_status_message,
							:get_likes_for_status_message,
							:get_number_of_comments_for_status_message
							]
  
  before_filter :require_post_write_permision, :only => [:create_status_message
							]

  before_filter :require_post_delete_permision, :only => [:delete_status_message
							]

# Can retrieve all status messages posted by given user
  def get_given_user_status_list
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
    statusMessageList=StatusMessage.all
    status_messages_array = Array.new
       statusMessageList.each do |i| 
	 if i.diaspora_handle==params[:diaspora_handle]
	        status = {author_id: i.author_id.nil? ? "":i.author_id, comments_count: i.comments_count.nil? ? "":i.comments_count, diaspora_handle_of_creator: i.diaspora_handle.nil? ? "":i.diaspora_handle, status_id: i.id.nil? ? "":i.id, likes_count: i.likes_count.nil? ? "":i.likes_count, text: i.text.nil? ? "":i.text}
        	status_messages_array.push status	
	 end 
       end	
	render :status => :ok, :json => {:users_status_messages_list => status_messages_array}	# Successfully render the Json response
    else
	render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Retrieve all comments related to a given status message
  def get_comments_for_status_message
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    status=StatusMessage.find_by_id(params[:id])
    if person && status
      if person.diaspora_handle==status.diaspora_handle
        commentList=Comment.all
        comment_list_array = Array.new
        commentList.each do |i| 
	  if i.commentable_id==status.id
	        comment = {author_id: i.author_id.nil? ? "":i.author_id, commentable_id: i.commentable_id.nil? ? "":i.commentable_id, id: i.id.nil? ? "":i.id, likes_count: i.likes_count.nil? ? "":i.likes_count, text: i.text.nil? ? "":i.text}
        	comment_list_array.push comment	
	  end  
        end
	render :status => :ok, :json => {:comment_list => comment_list_array}	# Successfully render the Json response
      else
	render :status => :unauthorized, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
	render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end
  
# Get number of likes of a given status message
  def get_likes_for_status_message
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @status=StatusMessage.find_by_id(params[:id])
    if @person && @status
      if @person.diaspora_handle==@status.diaspora_handle
	        @likes_count = {likes_count: @status.likes_count.nil? ? "": @status.likes_count.to_s()}	
	render :status => :ok, :json => {:likes_count => @likes_count}	# Successfully render the Json response
      else
	render :status => :unauthorized, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
	render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Get number of comments of a given status message
  def get_number_of_comments_for_status_message
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    status=StatusMessage.find_by_id(params[:id])
    if person && status
      if person.diaspora_handle==status.diaspora_handle
	        comments_count = {comments_count: status.comments_count.nil? ? "": status.comments_count.to_s()}	
	render :status => :ok, :json => {:comments_count => comments_count}	# Successfully render the Json response
      else
	render :status => :unauthorized, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
	render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Post a status message
  def create_status_message
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
    status_message=user.build_post(:status_message,{"text"=>params[:text],"aspect_ids"=>"all_aspects","location_coords"=>""})
      if status_message.save
        aspect_ids=user.aspect_ids
        aspects=user.aspects_from_ids(aspect_ids)
        user.add_to_streams(status_message, aspects)
        user.dispatch_post(status_message, :url => short_post_url(status_message.guid), :service_types => "")
	render :nothing => true	# Successfully created the status message
      end
    else
	render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Delete a status message
  def delete_status_message
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    status=StatusMessage.find_by_id(params[:id])
    if user && status
      if user.diaspora_handle==status.diaspora_handle
        post=user.posts.find(params[:id])
        user.retract(post)
	render :nothing => true	# Successfully deleted the status message
      else
	render :status => :unauthorized, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
	render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

end


