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

end
