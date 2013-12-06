class Api::UsersController < Api::ApiController

  before_filter :require_profile_read_permision, :only => [:get_user_contact_list,
                                                           :get_user_aspects_list,
							   :get_user_followed_tags_list,
							   :get_user_details,
							   :get_user_contact_handle_list,
                                                           :get_app_scopes_of_given_user,
							   ]

  before_filter :require_profile_write_permision, :only => [:edit_email,
                                                            :edit_first_name,
							    :edit_last_name,
							    :edit_user_location
							   ]
# Retrieve contact list of a given user

  def get_user_contact_list
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner.id
    if user
      contact_list=User.find_by_id(user).contact_person_ids
      if contact_list
        contact_list_array = Array.new
        contact_list.each do |i|  
	  person_as_json = Person.find_by_id(i).as_json
          person_url = person_as_json[:url]
	  person_url = person_url[1..-1]
          pod_url = Person.find_by_id(i).url
	  contact_url = pod_url + person_url
          person_avatar = person_as_json[:avatar]
          if person_avatar=="/assets/user/default.png"
	    person_avatar = pod_url + person_avatar[1..-1]
          end

          user_details = {first_name: (Person.find_by_id(i).first_name.nil? ? "": Person.find_by_id(i).first_name), last_name: (Person.find_by_id(i).last_name.nil? ? "": Person.find_by_id(i).last_name), diaspora_handle: (Person.find_by_id(i).diaspora_handle.nil? ? "": Person.find_by_id(i).diaspora_handle), location: (Person.find_by_id(i).location.nil? ? "": Person.find_by_id(i).location), birthday: (Person.find_by_id(i).birthday.nil? ? "": Person.find_by_id(i).birthday), gender: (Person.find_by_id(i).gender.nil? ? "": Person.find_by_id(i).gender), bio: (Person.find_by_id(i).bio.nil? ? "": Person.find_by_id(i).bio), url: (contact_url.nil? ? "": contact_url), avatar: (person_avatar.nil? ? "": person_avatar)}

	  if Person.find_by_id(i).profile.searchable
            contact_list_array.push user_details
	  end
        end
        render :status => :ok, :json => {:user_contact_list => contact_list_array}	# Successfully render the Json response
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Retrieve Aspects of a given user

  def get_user_aspects_list
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      aspect_list=user.aspects
      aspect_list_array=Array.new
      aspect_list.each do |i|

      aspect = {aspect_name: i.name.nil? ? "":i.name, id: i.id.nil? ? "":i.id, user_id: i.user_id.nil? ? "":i.user_id}

        aspect_list_array.push aspect
      end
      render :status => :ok, :json => {:users_aspects_list => aspect_list_array}	# Successfully render the Json response
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Retrieve Followed tags of a given user

  def get_user_followed_tags_list
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      tag_list=user.followed_tags
      render :status => :ok, :json => {:users_followed_tag_list => tag_list}	# Successfully render the Json response
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Retrieve details of a given user

  def get_user_details
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    if person
      person_as_json = person.as_json
      person_url = person_as_json[:url]
      person_url = person_url[1..-1]
      pod_url = person.url
      contact_url = pod_url + person_url
      person_avatar = person_as_json[:avatar]
      if person_avatar=="/assets/user/default.png"
        person_avatar = pod_url + person_avatar[1..-1]
      end

      user_details = {first_name: (person.first_name.nil? ? "": person.first_name), last_name: (person.last_name.nil? ? "": person.last_name), diaspora_handle: (person.diaspora_handle.nil? ? "": person.diaspora_handle), location: (person.location.nil? ? "": person.location), birthday: (person.birthday.nil? ? "": person.birthday), gender: (person.gender.nil? ? "": person.gender), bio: (person.bio.nil? ? "": person.bio),  url: (person.url.nil? ? "": person.url),  url: (contact_url.nil? ? "": contact_url),  avatar: (person_avatar.nil? ? "": person_avatar)}

      render :status => :ok, :json => {:user_details => user_details}	# Successfully render the Json response
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end


# Retrieve contact handle list of a given user

  def get_user_contact_handle_list
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      contact_handle_list = Array.new
      contact_list = user.contact_person_ids
      contact_list.each do |i|

        contact_handle={handle: Person.find_by_id(i).diaspora_handle.nil? ? "": Person.find_by_id(i).diaspora_handle}

        contact_handle_list.push contact_handle    
      end
      render :status => :ok, :json => {:user_contact_handle_list => contact_handle_list}	# Successfully render the Json response
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Retrieve app scopes of a given user

  def  get_app_scopes_of_given_user
    person = Person.find_by_diaspora_handle(params[:diaspora_handle])
    app=Dauth::RefreshToken.find_by_app_id(params[:id])
    if person && app
      handle=params[:diaspora_handle]    
      guid=app.user_guid
      if guid==person.guid
        app_scopes=app.scopes
	render :status => :ok, :json => {:user_app_scopes => app_scopes}	# Successfully render the Json response
      else
	render :status => :bad_request, :json => {:error => "401"}	# Accessing unauthorized contents
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Update user email address

  def edit_email
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      user.email=params[:email]
      if user.valid?
        user.save
	render :nothing => true	# email address edited successfully
      else
        render :status => :bad_request, :json => {:error => "402"}	# Accessing with an invalid type
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Update user first name

  def edit_first_name
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      profile=user.profile
      profile.first_name=params[:first_name]
      if profile.valid?
        profile.save
	render :nothing => true	# first name edited successfully
      else
	render :status => :bad_request, :json => {:error => "402"}	# Accessing with an invalid type
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Update user last name

  def edit_last_name
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      profile=user.profile
      profile.last_name=params[:last_name]
      if profile.valid?
        profile.save
	render :nothing => true	# last name edited successfully
      else
	render :status => :bad_request, :json => {:error => "402"}	# Accessing with an invalid type 
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end

# Update user location

  def edit_user_location
    user = Person.find_by_diaspora_handle(params[:diaspora_handle]).owner
    if user
      profile=user.profile
      profile.location=params[:location]
      if profile.valid?
        profile.save
	render :nothing => true	# location edited successfully
      else
	render :status => :bad_request, :json => {:error => "402"}	# Accessing with an invalid type 
      end
    else
      render :status => :bad_request, :json => {:error => "400"}	# Accessing with a bad request
    end
  end


end

