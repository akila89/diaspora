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
    mnfst = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJkZXZfaWQiOiJkaWxtYUBsb2NhbGhvc3Q6MzAwMCJ9.ZG37DRVgcf88hFP-TEr6-iDGoZXNbumttL
rvxGxkIsdjIc-Zo2aqFKaWDPMS9xwnw4erV5zTy5p9Cc1L1lSxnvHewZhCa9qr8ffRG-uf4SO9XbMZEPxKc7MscyTKoP8zvUKcxJAa5xhLRXH2aHYCTSH7mKVbbFZTp8_
6ykjwl87H65_gaEPoDyG2kvj4s3CfIiXZ7HwK8irbH0Re9C1SwPNtim_csZk_t8vyUsFXL1SBjWXOgbp28TTJQuZuvBYBu5Az0u3YODyOi9WwMaE3n6i21c6uKEH5a0t7
pWYoqqypdEbsO1yNk0g5d6v4lB096dQi5LVt3uOp0w_70kY2ms0HKw68qo9tQREuld4EbIKrj9I5W8qa5GpIu5FMl46Fd0mihUDE5ey3UnyfEfG95uTyFJrhhnPNZbRWh
bPct85Z4UfQrnSBjeh9_CbHcsLE8LgLqWlrEteaClK3WjENWuqTpJweH6QLcV2JUGYSsem2CQyXVNmGl0wHmeurev0DEKccG7VjIp2QtLY8mSrY6vFAbSIhfKMmnoA89F
FIL0uW2B3zksBhwo9Z9159w8Z0GalAHOb3EhmVN76Xayog-yA0_tEprrB-wwEGp1LSzONr7NWPhg19d7BBKnNGLXtBOVQsgM63ypF6dK9e1nP40yqE8GyPlJ5U_TUH4sY
Y5eU"
    res = Manifest.new.verify(mnfst)
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
