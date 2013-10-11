class Manifest < ActiveRecord::Base

  serialize :scopes, Array

  attr_accessible :app_description,
                  :app_name,
                  :app_id,
                  :app_version,
                  :dev_id,
                  :callback,
                  :manifest_ver,
                  :signed_jwt,
                  :scopes

  validates :app_description,  presence: true, length: { maximum: 50 }
  validates :app_version, presence: true
  VALID_URL_REGEX = /^(http|https):\/\/.+$/
  validates :callback, presence: true, format: { with: VALID_URL_REGEX }

  def sign private_key
    self.signed_jwt = JWT.encode(getManifestHash, OpenSSL::PKey::RSA.new(private_key),"RS256")
    self.save(:validate => false)
  end

  def verify
    developer_id = self.dev_id
    person = Webfinger.new(developer_id).fetch
    begin
      res=JWT.decode(self.signed_jwt, person.public_key)
      return true
    rescue JWT::DecodeError => e
      Rails.logger.info("Failed to verify the manifest from the developer: #{developer_id}; #{e.message}")
      return false
    end
  end

end
