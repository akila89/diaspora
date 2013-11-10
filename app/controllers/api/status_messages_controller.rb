class Api::StatusMessagesController < Api::ApiController

  before_filter :require_post_read_permision, :only => [:getGivenUserStatusList,
                                                        :getCommentsForStatusMessage,
                                                        :getGivenUserStatusListByHandle,
							:getLikesForStatusMessage,
							:getNumberOfCommentsForStatusMessage,
							:index]
  #before_filter :fetch_user, :except => [:index, :create]

  def fetch_user
    @statusMessage = StatusMessage.find_by_id(params[:id])
  end

# Can retrieve pod's statusmessage list
  def index
    @statusMessages = StatusMessage.all
    respond_to do |format|
      format.json { render json: @statusMessages }
      format.xml { render xml: @statusMessages }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @statusMessage }
      format.xml { render xml: @statusMessage }
    end
  end

# Can retrieve all status messages posted by given user
  def getGivenUserStatusList
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @statusMessageList=StatusMessage.all
    @status_messages_array = Array.new
       @statusMessageList.each do |i| 
	 if i.diaspora_handle==params[:diaspora_handle]
	        @status = {author_id: i.author_id.nil? ? "":i.author_id, comments_count: i.comments_count.nil? ? "":i.comments_count, diaspora_handle_of_creator: i.diaspora_handle.nil? ? "":i.diaspora_handle, status_id: i.id.nil? ? "":i.id, likes_count: i.likes_count.nil? ? "":i.likes_count, text: i.text.nil? ? "":i.text}
        	@status_messages_array.push @status	
	 end 
       end
    respond_to do |format|
      format.json { render json: @status_messages_array }
      format.xml { render xml: @status_messages_array }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve all comments related to a given status message
  def getCommentsForStatusMessage
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @status=StatusMessage.find_by_id(params[:id])
    if @person && @status
      if @person.diaspora_handle==@status.diaspora_handle
        @user=@person.owner
        @commentList=Comment.all
        @comment_list_array = Array.new
        @commentList.each do |i| 
	  if i.commentable_id==@status.id
	        @comment = {author_id: i.author_id.nil? ? "":i.author_id, commentable_id: i.commentable_id.nil? ? "":i.commentable_id, id: i.id.nil? ? "":i.id, likes_count: i.likes_count.nil? ? "":i.likes_count, text: i.text.nil? ? "":i.text}
        	@comment_list_array.push @comment	
	  end  
        end
      respond_to do |format|
        format.json { render json: @comment_list_array }
        format.xml { render xml: @comment_list_array }
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
  
# Get number of likes of a given status message
  def getLikesForStatusMessage
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @status=StatusMessage.find_by_id(params[:id])
    if @person && @status
      if @person.diaspora_handle==@status.diaspora_handle
	        @likes_count = {likes_count: @status.likes_count.nil? ? "": @status.likes_count}.to_json	
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

# Get number of comments of a given status message
  def getNumberOfCommentsForStatusMessage
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @status=StatusMessage.find_by_id(params[:id])
    if @person && @status
      if @person.diaspora_handle==@status.diaspora_handle
	        @comments_count = {comments_count: @status.comments_count.nil? ? "": @status.comments_count}.to_json	
      respond_to do |format|
        format.json { render json: @comments_count }
        format.xml { render xml: @comments_count }
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

# Post a status message
  def createStatusMessage
    @user=current_user
    @status_message=@user.build_post(:status_message,{"text"=>params[:text],"aspect_ids"=>"all_aspects","location_coords"=>""})
    if @status_message.save
    @aspect_ids=@user.aspect_ids
    @aspects=@user.aspects_from_ids(@aspect_ids)
    current_user.add_to_streams(@status_message, @aspects)
    current_user.dispatch_post(@status_message, :url => short_post_url(@status_message.guid), :service_types => "")
    end
    respond_to do |format|
      format.json { render :nothing => true }
      format.xml { render :nothing => true }
    end
  end

# Delete a status message
  def deleteStatusMessage
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @user=@person.owner
    @status=StatusMessage.find_by_id(params[:id])
    if @person && @status
      if @person.diaspora_handle==@status.diaspora_handle
        @post=@user.posts.find(params[:id])
        @user.retract(@post)
        respond_to do |format|
          format.json { render :nothing => true }
          format.xml { render :nothing => true }
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

#=> listing statusmessages
#   url: http://localhost:3000/api/statusmessages
#   method: GET




