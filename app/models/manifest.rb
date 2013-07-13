class Manifest < ActiveRecord::Base
  attr_accessible :app_description, :app_id, :app_ver, :comment_write, :comments_read, :dev_id, :manifest_ver, :post_delete, :post_read, :post_write, :profile_read, :url_err_Oauth, :url_err_login, :url_success
  validates :app_description,  presence: true, length: { maximum: 50 }
  validates :app_ver, presence: true
  VALID_EMAIL_REGEX = /^(http|https):\/\/.+$/
  validates :url_err_login, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :url_success, presence: true, format: { with: VALID_EMAIL_REGEX }

  def sign (mnfst,private_key)
    JWT.encode(mnfst, OpenSSL::PKey::RSA.new(private_key),"RS256")
  end
  
  def verify(mnfst)
     manifest_payload = JWT.decode(mnfst, nil, false)
     developer_id = manifest_payload["dev_id"]
     person = Webfinger.new(developer_id).fetch
     begin
       res=JWT.decode(mnfst, person.public_key)
       Rails.logger.info("Ela ela elaaaa #{res}")
     rescue JWT::DecodeError => e
      Rails.logger.info("Failed to verify the manifest from the developer: #{developer_id}; #{e.message}")
      raise e
     rescue => e
      Rails.logger.info("Failed to verify the manifest from the developer: #{developer_id}; #{e.message}")
      raise e
     end
          
  end

   def createManifestJson dev_id, app_id, app_discription, app_version, success_url, error_login, list
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
