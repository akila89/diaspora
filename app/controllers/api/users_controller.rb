class Api::UsersController < Api::ApiController

  before_filter :require_profile_read_permision, :only => [:getPodPersonList,
                                                           :getUserpersonList,
                                                           :getUsersAspectsList,
                                                           :getUserDetailsUsingHandler,
                                                           :getUserpersonListUsingHandle]
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
    @personList = User.all
    @size=@personList.size();
    @array = Array.new
       for i in 0..@size
         @array.push Person.all[i]
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end
  
# Can retrieve friendlist for a given user
  def getUserpersonList
    @personList = User.find_by_id(params[:id]).contact_person_ids
    @size=@personList.length();
    @array = Array.new
       @personList.each do |i|
	 @array.push Person.all[i-1]      
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end

# Can retrieve Aspects of a given user
  def getUsersAspectsList
    @user = User.find_by_id(params[:id]).diaspora_handle
    @aspects = Aspect.all;
    @array = Array.new
       @aspects.each do |i|
	 if i.user.diaspora_handle==@user
		@array.push i 
	 end
	      
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end

# Can retrieve user details from his diaspora handle
# ex: using sandaruwan3@localhost:3000
  def getUserDetailsUsingHandler
    @handle=params[:diaspora_handle]
    @users=User.all
    @array = Array.new
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@array.push i 
	 end
    end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
    end
  end


# Can retrieve friendlist for a given user using his handle
# ex: using sandaruwan3@localhost:3000
  def getUserpersonListUsingHandle
    @handle=params[:diaspora_handle]
    @users=User.all
    @user
    @array = Array.new
    @users.each do |i|
	 if i.diaspora_handle==@handle
		@user=i
	 end
    end
       @personList = @user.contact_person_ids
       @personList.each do |i|
	 @array.push Person.all[i-1]      
       end
    respond_to do |format|
      format.json { render json: @array }
      format.xml { render xml: @array }
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



