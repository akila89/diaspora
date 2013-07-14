class Dauth::AccessRequest < ActiveRecord::Base
  serialize :scopes, Array

  attr_accessible :auth_token,
                  :callback,
                  :dev_handle,
                  :scopes,
                  :app_id,
                  :app_name,
                  :app_description,
                  :app_version

  validates :auth_token,  presence: true, uniqueness: true
  validates :callback,  presence: true
  validates :scopes,  presence: true

  before_validation :generateToken, :on => :create

  def generateToken
    self.auth_token = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end
end
