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

  def download
    appId=params[:appID]
    scopes=params[:scopes]
    manifest=Manifest.where(["app_id = ?", appId]).select("app_description,app_id,app_ver,comment_write,comments_read,dev_id,manifest_ver,post_delete,post_read,post_write,profile_read,url_err_Oauth,url_err_login,url_success").first
    res=manifest.createManifestJson manifest.dev_id, manifest.app_id, manifest.app_description, manifest.app_ver, manifest.url_success,manifest.url_err_login, scopes 
    send_data res, :filename => "#{current_user.username}_app.json", :type => :json
   end

  def generateManifest
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
	    manifest.url_success=u[:success_url]        
	    manifest.url_err_login=u[:error_login_url]                
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
      end
      if manifest.save
      render "manifest/downloadManifest", :locals => {:appId => appId, :scope => scopes}
      else
       redirect_to :back
       flash[:notice] = "Missing or incorrect values"
      end
   end 

end
