class ManifestController < ApplicationController
	
  def index
    
  end

  def edit

  end

  def sign    
    mnfst = {"Hellp" => "Madhawa"}
    manifest = Manifest.new
    res=manifest.sign(mnfst)
    Rails.logger.info("Content: for #{res}")  
  end

  def verify
    
  end

  def export
    appId=params[:appID]
    scopes=params[:scopes]
    manifest=Manifest.where(["app_id = ?", appId]).select("app_description,app_id,app_ver,comment_write,comments_read,dev_id,manifest_ver,post_delete,post_read,post_write,profile_read,url_err_Oauth,url_err_login,url_success").first
    res=manifest.createMenifestJson manifest.dev_id, manifest.app_id, manifest.app_description, manifest.app_ver, manifest.url_success,manifest.url_err_login, scopes 
    send_data res, :filename => "#{current_user.username}_app.json", :type => :json
   end

  def downloadManifest
	manifest = Manifest.new
	manifest.dev_id=current_user.diaspora_handle           
        stamp=Time.now.to_i
        random=Random.new.rand(1..60)
        appId  ="#{random}#{stamp}"
	manifest.app_id= appId 
      if u = params[:developer]
	scopes = Array.new
        if u[:app_discription]  
	    manifest.app_description=u[:app_discription]
	end
        if u[:app_version]
	    manifest.app_ver=u[:app_version]  
	end
	if u[:success]
	    manifest.url_success=u[:success]        
	end
	if u[:error_login]
	    manifest.url_err_login=u[:error_login]     
	end
	if u[:error_auth]
	    manifest.url_err_Oauth=u[:error_auth]        
	end
	if u[:post_read]           
	    if u[:post_read]=='1'
	    scopes.push("postread")
	    end
	end
	if u[:post_write]                   
	    if u[:post_write]=='1'
	    scopes.push("postwrite")
	    end
	end
	if u[:post_delete]            
	    if u[:post_delete]=='1'
	    scopes.push("postdelete")
	    end
	end
	if u[:comment_read]           
	    if u[:comment_read]=='1'
	    scopes.push("commentread")
	    end
	end
	if u[:comment_write]          
	    if u[:comment_write]=='1'
	    scopes.push("commentwrite")
	    end
	end
	if u[:comment_delete]          
	    if u[:comment_delete]=='1'
	    scopes.push("commentdelete")
	    end
	end
	if u[:profile_read]               
	    if u[:profile_read]=='1'
	    scopes.push("profileread")
	    end
	end
	if u[:profile_write]               
	    if u[:profile_write]=='1'
	    scopes.push("profilewrite")
	    end
	end
	if u[:profile_delete]               
	    if u[:profile_delete]=='1'
	    scopes.push("profiledelete")
	    end
	end
	manifest.save
        render "manifest/downloadManifest", :locals => {:appId => appId, :scope => scopes}
      end
   end 

end
