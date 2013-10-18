class Api::StatusMessagesController < Api::ApiController

  before_filter :require_post_read_permision, :only => [:getGivenUserStatusList,
                                                        :getCommentsForStatusMessage,
                                                        :getGivenUserStatusListByHandle]
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
    @size=@statusMessageList.size()
    @array = Array.new
       @statusMessageList.each do |i| 
	 if i.diaspora_handle==@user
		@array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end

# Can retrieve all comments related to a given status message
  def getCommentsForStatusMessage
    @status=StatusMessage.find_by_id(params[:id])
    @commentList=Comment.all
    @array = Array.new
       @commentList.each do |i| 
	 if i.commentable_id==@status.id
		@array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end
  

# Can retrieve all status messages posted by given user using handle
  def getGivenUserStatusListByHandle
    @user=params[:diaspora_handle]
    @statusMessageList=StatusMessage.all
    @size=@statusMessageList.size()
    @array = Array.new
       @statusMessageList.each do |i| 
	 if i.diaspora_handle==@user
		@array.push i	
	 end  
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end
end


#API Requests:

#=> listing statusmessages
#   url: http://localhost:3000/api/statusmessages
#   method: GET




