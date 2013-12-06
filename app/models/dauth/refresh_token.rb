class Dauth::RefreshToken < ActiveRecord::Base
  
  serialize :scopes, Array

  belongs_to :user
   
  attr_accessible :app_id, 
                  :scopes, 
                  :secret, 
                  :token
                  
  validates :token,  presence: true, uniqueness: true
  validates :app_id,  presence: true
  validates :scopes,  presence: true
  validates :user_id,  presence: true
  validates :secret,  presence: true
  
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
