class Api::StatusMessagesController < Api::ApiController

  before_filter :require_post_read_permision, :only => [:getGivenUserStatusList,
                                                        :getCommentsForStatusMessage,
                                                        :getGivenUserStatusListByHandle,
							:getLikesForStatusMessage,
							:getNumberOfCommentsForStatusMessage]
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
    @user=User.find_by_id(params[:id]).diaspora_handle
    @statusMessageList=StatusMessage.all
    @status_messages_array = Array.new
       @statusMessageList.each do |i| 
	 if i.diaspora_handle==@user
		@status_messages_array.push i	
	 end 
       end
    respond_to do |format|
      format.json { render json: @status_messages_array }
      format.xml { render xml: @status_messages_array }
    end
  end

# Can retrieve all comments related to a given status message
  def getCommentsForStatusMessage
    @status=StatusMessage.find_by_id(params[:id])
    @commentList=Comment.all
    @comment_list_array = Array.new
       @commentList.each do |i| 
	 if i.commentable_id==@status.id
		@comment_list_array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @comment_list_array }
      format.xml { render xml: @comment_list_array }
    end
  end
  

# Can retrieve all status messages posted by given user using handle
  def getGivenUserStatusListByHandle
    @user=params[:diaspora_handle]
    @statusMessageList=StatusMessage.all
    @status_messages_array = Array.new
       @statusMessageList.each do |i| 
	 if i.diaspora_handle==@user
		@status_messages_array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @status_messages_array }
      format.xml { render xml: @status_messages_array }
    end
  end

# Get number of likes of a given status message
  def getLikesForStatusMessage
    @likes_count=StatusMessage.find_by_id(params[:id]).likes_count
    respond_to do |format|
      format.json { render json: @likes_count }
      format.xml { render xml: @likes_count }
    end
  end

# Get number of comments of a given status message
  def getNumberOfCommentsForStatusMessage
    @comments_count=StatusMessage.find_by_id(params[:id]).comments_count
    respond_to do |format|
      format.json { render json: @comments_count }
      format.xml { render xml: @comments_count }
    end
  end

end


#API Requests:

#=> listing statusmessages
#   url: http://localhost:3000/api/statusmessages
#   method: GET




