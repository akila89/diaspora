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
  validates_uniqueness_of :app_id, :scope => :user_guid
  
  before_validation :generateToken, :on => :create
  before_validation :generateSecret, :on => :create

  
  
  private

  def generateToken
    self.token = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end

  def generateSecret
    self.secret = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end
  
end
