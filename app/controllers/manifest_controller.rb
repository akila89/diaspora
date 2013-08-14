class ManifestController < ApplicationController
	
  def index
    
  end

  def edit

  end

  def download
    appId=params[:appID]
    manifest=Manifest.where(["app_id = ?", appId]).first
    res=manifest.createManifestJson
    send_data res, :filename => "#{current_user.username}_app.json", :type => :json
   end

  def generateManifest

	manifest = Manifest.new
	manifest.dev_id=current_user.diaspora_handle           
    	stamp=Time.now.to_i
   	random=Random.new.rand(1..60)
    	appId ="#{random}#{stamp}"
	manifest.app_id= appId
        if u = params[:manifest]
            @manifest=manifest.app_name=u[:app_name]
 	    manifest.app_name=u[:app_name]
	    manifest.app_description=u[:app_discription]
	    manifest.app_version=u[:app_version]
	    manifest.callback=u[:callback_url]
	    scopes = Array.new
	    if u[:post_read]=='1'
	      scopes.push("post_read")
	    end
	    if u[:post_write]=='1'
	      scopes.push("post_write")
	    end
	    if u[:post_delete]=='1'
	      scopes.push("post_delete")
	    end
	    if u[:comment_read]=='1'
	      scopes.push("comment_read")
	    end
	    if u[:comment_write]=='1'
	      scopes.push("comment_write")
	    end
	    if u[:comment_delete]=='1'
	      scopes.push("comment_delete")
	    end
	    if u[:profile_read]=='1'
	      scopes.push("profile_read")
	    end
	    if u[:profile_write]=='1'
	      scopes.push("profilewrite")
	    end
	    if u[:profile_delete]=='1'
	      scopes.push("profiledelete")
	    end
	    manifest.scopes = scopes
        end

    	private_key = current_user.serialized_private_key
    	manifest.sign(private_key)

    	if manifest.save
      		render "manifest/downloadManifest", :locals => {:appId => appId}
    	else
       		redirect_to :back
		message=manifest.errors.full_messages.to_sentence.split(',').first
       		flash[:notice] = message
    	end
  end 
  def getCurrentuserDetails 
	return current_user.diaspora_handle,current_user.email,current_user.username
  end
  def getScopes


  end
end
