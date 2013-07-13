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

  def sign private_key
    self.signed_jwt = JWT.encode(getManifestHash, OpenSSL::PKey::RSA.new(private_key),"RS256")
    self.save(:validate => false)
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
  
  def getManifestHash
    manifest_hash={
		  :dev_id=>self.dev_id,
      :manifest_version=>"1.0",
		  :app_details=>{
	      :id=> self.app_id,
	      :description=>self.app_description,
	      :version=>self.app_version
	    },
		  :callbacks=>{
			  :success=>self.url_success,
			  :error=>self.url_err_login
			},
		  :access=>self.scopes,
	  }
	  manifest_hash
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
		  :signed_jwt=>manifest.signed_jwt,
	  }
	  manifest_json.to_json
	end
end
