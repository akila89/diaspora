class Dauth::RefreshToken < ActiveRecord::Base
  
  serialize :scopes, Array
   
  attr_accessible :app_id, 
                  :scopes, 
                  :secret, 
                  :token, 
                  :user_guid
                  
  validates :token,  presence: true, uniqueness: true
  validates :app_id,  presence: true
  validates :scopes,  presence: true
  validates :user_guid,  presence: true
  validates :secret,  presence: true
  
  before_validation :generateToken, :on => :create
  before_validation :generateSecret, :on => :create

  def self.create_for_access_request_for_user access_request, user
    refresh_token = Dauth::RefreshToken.new
    refresh_token.app_id = access_request.app_id
    refresh_token.scopes = access_request.scopes
    refresh_token.user_guid = user.guid
    refresh_token
  end

  private

  def generateToken
    self.token = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end

  def generateSecret
    self.secret = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end
end
