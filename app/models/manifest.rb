class Manifest < ActiveRecord::Base

  serialize :scopes, Array

  :app_description
  :app_name
  :app_id
  :app_verson
  :dev_id
  :callback_url
	:redirect
  :manifest_ver
  :signed_jwt
  :scopes

  validates :app_name, presence: true
  validates :app_description, length: { maximum: 500 }
  VALID_URL_REGEX = /^(http|https):\/\/.+$/
  validates :callback_url, presence: true, format: { with: VALID_URL_REGEX }

  def sign private_key
    self.signed_jwt = JWT.encode(get_manifest_hash, OpenSSL::PKey::RSA.new(private_key), "RS256")
  end

  def verify
    developer_id = self.dev_id
    person = Webfinger.new(developer_id).fetch
    JWT.decode(self.signed_jwt, person.public_key)
  end


  def get_manifest_hash
    {
      :dev_id => self.dev_id,
      :manifest_version => "1.0",
      :app_details => {
        :name => self.app_name,
        :id => self.app_id,
        :description => self.app_description,
        :version => self.app_version
      },
      :callback => self.callback_url,
	    :redirect=>self.redirect,
      :access => self.scopes,
    }
  end

  def create_manifest_json
    manifest_hash = self.get_manifest_hash
    manifest_hash[:signed_jwt] = self.signed_jwt
    manifest_hash.to_json
  end

  def self.by_signed_jwt jwt
    manifest = Manifest.new
    begin
     payload = JWT.decode(jwt, nil, false)
    rescue JWT::DecodeError => e
     return nil
    end  
    manifest.dev_id = payload["dev_id"]
    manifest.callback_url = payload["callback"]
    manifest.scopes = payload["access"]
    manifest.app_id = payload["app_details"]["id"]
    manifest.app_name = payload["app_details"]["name"]
    manifest.app_description = payload["app_details"]["description"]
    manifest.app_version = payload["app_details"]["version"]
    manifest.signed_jwt = jwt
    manifest
  end
end
