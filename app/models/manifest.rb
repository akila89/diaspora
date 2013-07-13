class Manifest < ActiveRecord::Base
  serialize :scopes, Array

  attr_accessible :app_description,
                  :app_id,
                  :app_version,
                  :dev_id,
                  :url_success,
                  :url_err_login,
                  :url_err_Oauth,
                  :manifest_ver,
                  :signed_jwt,
                  :scopes

  validates :app_description,  presence: true, length: { maximum: 50 }
  validates :app_version, presence: true
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

  def createManifestJson manifest
		manifest_json={
		  :dev_id=>manifest.dev_id,
      :manifest_version=>"1.0",
		  :app_details=>{
	      :id=> manifest.app_id,
	      :description=>manifest.app_description,
	      :version=>manifest.app_version
	    },
		  :callbacks=>{
			  :success=>manifest.url_success,
			  :error=>manifest.url_err_login
			},
		  :access=>manifest.scopes,
	  }
	  manifest_json.to_json
	end
end
