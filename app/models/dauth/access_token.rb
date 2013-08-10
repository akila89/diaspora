class Dauth::AccessToken < ActiveRecord::Base
  attr_accessible :refresh_token, 
                  :secret, 
                  :token        
             
  validates :refresh_token,  presence: true, uniqueness: true
  validates :token,  presence: true
  validates :secret,  presence: true
  
  before_validation :generateToken, :on => :create
  before_validation :generateSecret, :on => :create

  def generateToken
    self.token = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end

  def generateSecret
    self.secret = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end
  
end
