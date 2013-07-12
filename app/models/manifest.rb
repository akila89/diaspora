class Manifest < ActiveRecord::Base
  attr_accessible :app_description, :app_id, :app_ver, :comment_write, :comments_read, :dev_id, :manifest_ver, :post_delete, :post_read, :post_write, :profile_read, :url_err_Oauth, :url_err_login, :url_success
  
  def sign (mnfst)
    user = current_user
    JWT.encode(mnfst, OpenSSL::PKey::RSA.new(user.serialized_private_key),"RS256")
  end
  
  def verify
 
  end
  
  def get_host_meta
    url=host_meta_url
      if user_signed_in?
          Rails.logger.info("Getting: #{url} for Sandaruwan")
    begin
      res = Faraday.get(url)
      return false if res.status == 404
      res.body
    rescue OpenSSL::SSL::SSLError => e
      Rails.logger.info "Failed to fetch #{url}: SSL setup invalid"
      raise e
    rescue => e
      Rails.logger.info("Failed to fetch: #{url} for Sandaruwan; #{e.message}")
      raise e
    end
    else
      @css_framework = :bootstrap # Hack, port site to one framework
      render file: Rails.root.join("public", "default.html"),
             layout: 'application'
    end
  end
  
  def host_meta_url
    account ="sandaruwan@spyurk.am"
    domain = account.split('@')[1]
    "http://#{domain}/.well-known/host-meta"
  end

   def createMenifestJson dev_id, app_id, app_discription, app_version, success_url, error_login, list
		manifest={ 

		:dev_id=>dev_id,
                :manifest_version=>"1.0",
		:app_details=>{
	      		:id=> app_id,
	                :description=>app_discription,
	                :version=>app_version
	                },
		:callbacks=>{
			:success=>success_url,
			:error=>error_login
			},
		:access=>list,
	}
        #message=self.encodeJson "asda", menifest.to_json
	#flash[:notice] = menifest.to_json
	manifest.to_json
	end
end
