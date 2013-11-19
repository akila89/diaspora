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
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @person_id=@person.id
    @person_list=User.find_by_id(@person_id).contact_person_ids
    if @person_list
    @person_list_array = Array.new
       @person_list.each do |i|  

         @user_details = {first_name: (Person.find_by_id(i).first_name.nil? ? "": Person.find_by_id(i).first_name), last_name: (Person.find_by_id(i).last_name.nil? ? "": Person.find_by_id(i).last_name), diaspora_handle: (Person.find_by_id(i).diaspora_handle.nil? ? "": Person.find_by_id(i).diaspora_handle), location: (Person.find_by_id(i).location.nil? ? "": Person.find_by_id(i).location), birthday: (Person.find_by_id(i).birthday.nil? ? "": Person.find_by_id(i).birthday), gender: (Person.find_by_id(i).gender.nil? ? "": Person.find_by_id(i).gender)}

         @person_list_array.push @user_details
       end
    respond_to do |format|
      format.json { render :json => { :user_person_list => @person_list_array }}
      format.xml { render xml: @person_list_array }
    end
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve Aspects of a given user using handle
  def getUsersAspectsList
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @aspect_list=@user.aspects
    @aspect_list_array=Array.new
    @aspect_list.each do |i|
	@aspect = {aspect_name: i.name.nil? ? "":i.name, id: i.id.nil? ? "":i.id, user_id: i.user_id.nil? ? "":i.user_id}
        @aspect_list_array.push @aspect
    end
    respond_to do |format|
      format.json { render json: @aspect_list_array }
      format.xml { render xml: @aspect_list_array }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve Followed tags of a given user by handle
  def getUserFollowedTagsList
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @tag_list=@user.followed_tags
    respond_to do |format|
      format.json { render json: @tag_list }
      format.xml { render xml: @tag_list }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve user details from his diaspora handle
  def getUserDetails
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user_details = {first_name: (@person.first_name.nil? ? "": @person.first_name), last_name: (@person.last_name.nil? ? "": @person.last_name), diaspora_handle: (@person.diaspora_handle.nil? ? "": @person.diaspora_handle), location: (@person.location.nil? ? "": @person.location), birthday: (@person.birthday.nil? ? "": @person.birthday), gender: (@person.gender.nil? ? "": @person.gender), bio: (@person.bio.nil? ? "": @person.bio),  url: (@person.url.nil? ? "": @person.url),  as_json: (@person.as_json.nil? ? "": @person.as_json)}
    respond_to do |format|
      format.json { render json: @user_details.to_json }
      format.xml { render xml: @user_details }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end


# Can retrieve person handle list of a given user using his handle

  def getUserpersonHandleList
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
      @user=@person.owner
      @person_handle_list = Array.new
      @personList = @user.contact_person_ids
       @personList.each do |i|
         @person_handle={handle: Person.find_by_id(i).diaspora_handle.nil? ? "": Person.find_by_id(i).diaspora_handle}
	 @person_handle_list.push @person_handle    
       end
    respond_to do |format|
      format.json { render json: @person_handle_list }
      format.xml { render xml: @person_handle_list }
    end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can retrieve scopes for a given user using his handle and app Id
  def  getAppScopesOfGivenUser
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    @app=Dauth::RefreshToken.find_by_app_id(params[:id])
    if @person && @app
    @handle=params[:diaspora_handle]    
    @guid=@app.user_guid
    @users=User.all
    @app_user
    @app_scopes
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@app_user=i.guid
	 end
    end
      if @guid==@person.guid
      @app_scopes=@app.scopes
      respond_to do |format|
        format.json { render json: @app_scopes }
        format.xml { render xml: @app_scopes }
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

# Can update user email address
  def editEmail
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @email=params[:email]
    @user.email=@email
      if @user.valid?
        @user.save
        respond_to do |format|
      	 format.json { render :nothing => true }
      	 format.xml { render :nothing => true }
        end
      else
        respond_to do |format|
          format.json { render :status => :bad_request, :json => {:error => 502}}  # invalid attribute substitution
        end
      end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can update user profile first name
  def editFirstName
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @profile=@user.profile
    @first_name=params[:first_name]
    @profile.first_name=@first_name
      if @profile.valid?
        @profile.save
        respond_to do |format|
      	 format.json { render :nothing => true }
      	 format.xml { render :nothing => true }
        end
      else
        respond_to do |format|
          format.json { render :status => :bad_request, :json => {:error => 502}}  # invalid attribute substitution
        end
      end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can update user profile last name
  def editLastName
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @profile=@user.profile
    @last_name=params[:last_name]
    @profile.last_name=@last_name
      if @profile.valid?
        @profile.save
        respond_to do |format|
      	 format.json { render :nothing => true }
      	 format.xml { render :nothing => true }
        end
      else
        respond_to do |format|
          format.json { render :status => :bad_request, :json => {:error => 502}}  # invalid attribute substitution
        end
      end
    else
    respond_to do |format|
      format.json { render :status => :bad_request, :json => {:error => 500}}
    end
    end
  end

# Can update user location
  def editUserLocation
    @person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if @person
    @user=@person.owner
    @profile=@user.profile
    @location=params[:location]
    @profile.location=@location
      if @profile.valid?
        @profile.save
        respond_to do |format|
      	 format.json { render :nothing => true }
      	 format.xml { render :nothing => true }
        end
      else
        respond_to do |format|
          format.json { render :status => :bad_request, :json => {:error => 502}}  # invalid attribute substitution
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

