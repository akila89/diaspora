class Api::UsersController < Api::ApiController

  before_filter :require_profile_read_permision, :only => [:getPodPersonList,
                                                           :getUserpersonList,
                                                           :getUsersAspectsList,
                                                           :getUserDetailsUsingHandler,
                                                           :getUserpersonListUsingHandle,
							   :getUsersAspectsListByHandle,
							   :getUserFollowedTagsList,
							   :getUserFollowedTagsListUsingHandle,
                                                           :getAppScopesOfGivenUser,
							   :index,
							   :show]
  before_filter :fetch_user, :except => [:index, :create]

 def fetch_user
    @user = User.find_by_id(params[:id])
  end

# Can retrieve pod user list
  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: @users }
      format.xml { render xml: @users }
    end
  end

# Can retrieve user specified by the id
  def show
    respond_to do |format|
      format.json { render json: @user }
      format.xml { render xml: @user }
    end
  end

# Can retrieve current pod personlist
  def getPodPersonList
    @person_list = User.all
    @size=@person_list.size();
    @person_list_array = Array.new
       for i in 0..@size
         @person_list_array.push Person.all[i]
       end
    respond_to do |format|
      format.json { render json: @person_list_array }
      format.xml { render xml: @person_list_array }
    end
  end
  
# Can retrieve friendlist for a given user by handle
  def getUserpersonList
    @person_list = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person_list
    @person_id=@person_list.id
    @person_list=User.find_by_id(@person_id).contact_person_ids
    @person_list_array = Array.new
       @person_list.each do |i|  
         @fruit = {first_name: Person.all[i-1].first_name, last_name: Person.all[i-1].last_name, diaspora_handle: Person.all[i-1].diaspora_handle, 	        location: Person.all[i-1].location, birthday: Person.all[i-1].birthday, gender: Person.all[i-1].gender}.to_json  
         @person_list_array.push @fruit
       end
    respond_to do |format|
      format.json { render json: @person_list_array }
      format.xml { render xml: @person_list_array }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve Aspects of a given user
  def getUsersAspectsList
    @aspects = User.find_by_id(params[:id]).aspects
    respond_to do |format|
      format.json { render json: @aspects }
      format.xml { render xml: @aspects }
    end
  end

# Can retrieve Aspects of a given user using handle
  def getUsersAspectsListByHandle
    @handle=params[:diaspora_handle]
    @users=User.all
    @aspects_array = Array.new
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@aspects_array.push i.aspects 
	 end
    end
    respond_to do |format|
      format.json { render json: @aspects_array }
      format.xml { render xml: @aspects_array }
    end
  end

# Can retrieve Followed tags of a given user
  def getUserFollowedTagsList
    @tags = User.find_by_id(params[:id]).followed_tags
    respond_to do |format|
      format.json { render json: @tags }
      format.xml { render xml: @tags }
    end
  end

# Can retrieve Followed tags of a given user by handle
  def getUserFollowedTagsListUsingHandle
    @handle=params[:diaspora_handle]
    @users=User.all
    @tags_array = Array.new
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@tags_array.push i.followed_tags 
	 end
    end
    respond_to do |format|
      format.json { render json: @tags_array }
      format.xml { render xml: @tags_array }
    end
  end

# Can retrieve user details from his diaspora handle
# ex: using sandaruwan3@localhost:3000
  def getUserDetailsUsingHandler
    @handle=params[:diaspora_handle]
    @users=User.all
    @detail_array = Array.new
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@detail_array.push i 
	 end
    end
    respond_to do |format|
      format.json { render json: @detail_array }
      format.xml { render xml: @detail_array }
    end
  end


# Can retrieve friendlist for a given user using his handle
# ex: using sandaruwan3@localhost:3000
  def getUserpersonListUsingHandle
    @handle=params[:diaspora_handle]
    @users=User.all
    @user
    @person_handle_list = Array.new
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@user=i
	 end
    end
       @personList = @user.contact_person_ids
       @personList.each do |i|
	 @person_handle_list.push Person.all[i-1].diaspora_handle      
       end
    respond_to do |format|
      format.json { render json: @person_handle_list }
      format.xml { render xml: @person_handle_list }
    end
  end

# Can retrieve scopes for a given user using his handle and app Id
  def  getAppScopesOfGivenUser
    @appId=Dauth::ThirdpartyApp.find(params[:id]).app_id
    @handle=params[:diaspora_handle]
    @apps=Dauth::RefreshToken.all
    @app
    @apps.each do |i|
	 if i.app_id==@appId
		@app=i
	 end
    end
    @guid=@app.user_guid
    @users=User.all
    @app_user
    @app_scopes
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@app_user=i.guid
	 end
    end
    if @guid==@app_user
    @app_scopes=@app.scopes
    end
    respond_to do |format|
      format.json { render json: @app_scopes }
      format.xml { render xml: @app_scopes }
    end
  end

# Can update user email address
  def editEmailAddress
    @user=current_user
    @user.email=params[:email]
    @user.save
    respond_to do |format|
      format.json { render :nothing => true }
      format.xml { render :nothing => true }
    end
  end

# Can update user profile first name
  def editFirstName
    @user=current_user
    @profile=@user.profile
    @profile.first_name=params[:first_name]
    @profile.save
    respond_to do |format|
      format.json { render :nothing => true }
      format.xml { render :nothing => true }
    end
  end

# Can update user profile last name
  def editLastName
    @user=current_user
    @profile=@user.profile
    @profile.last_name=params[:last_name]
    @profile.save
    respond_to do |format|
      format.json { render :nothing => true }
      format.xml { render :nothing => true }
    end
  end

# Can update user location
  def editUserLocation
    @user=current_user
    @profile=@user.profile
    @profile.location=params[:location]
    @profile.save
    respond_to do |format|
      format.json { render :nothing => true }
      format.xml { render :nothing => true }
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



# Can retrieve friendlist for a given user
#  def getUserpersonList
#    @person_list = User.find_by_id(params[:id])
#    if @person_list
#    @person_list=User.find_by_id(params[:id]).contact_person_ids   
#    @person_list_array = Array.new
#       @person_list.each do |i|
#	 #@person_list_array.push Person.all[i-1]    
#         @fruit = {first_name: Person.all[i-1].first_name, last_name: Person.all[i-1].last_name, diaspora_handle: Person.all[i-1].diaspora_handle, 	        location: Person.all[i-1].location, birthday: Person.all[i-1].birthday, gender: Person.all[i-1].gender}.to_json  
#         @person_list_array.push @fruit
#       end
#    respond_to do |format|
#      format.json { render json: @person_list_array }
#      format.xml { render xml: @person_list_array }
#    end
#    else
#    respond_to do |format|
#      format.json { render json: "error='500'"}
#    end
#    end
#  end

