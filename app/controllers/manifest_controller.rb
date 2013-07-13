class ManifestController < ApplicationController
	
  def index
    
  end

  def edit

  end

  def sign    
    mnfst = {"dev_id" => "dilma@localhost:3000"} # Testing 
    private_key = current_user.serialized_private_key
    res = Manifest.new.sign(mnfst,private_key)
    Rails.logger.info("Content: for #{res}")  
  end

  def verify
    signed_manifest= params[:signed_manifest]
    Rails.logger.info("content of the signed manifest #{signed_manifest}")
begin 
  res = Manifest.new.verify(signed_manifest)
rescue => e
  Rails.logger.info("Error occured #{e.message}")
end
    if res
      @css_framework = :bootstrap # Hack, port site to one framework
      render file: Rails.root.join("public", "default.html"),
             layout: 'application'
    end
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
	    manifest.app_description=u[:app_discription]
	    manifest.app_ver=u[:app_version]  
	    manifest.url_success=u[:success]        
	    manifest.url_err_login=u[:error_login]     
	    manifest.url_err_Oauth=u[:error_auth]                 
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
	manifest.save
        render "manifest/downloadManifest", :locals => {:appId => appId, :scope => scopes}
      end
   end 

end
