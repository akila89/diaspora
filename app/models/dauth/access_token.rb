class Dauth::AccessToken < ActiveRecord::Base

  belongs_to :refresh_token, class_name: 'Dauth::RefreshToken'

  attr_accessible :secret,
                  :expire_at,
                  :token

  validates :refresh_token,  presence: true
  validates :token,  presence: true, uniqueness: true
  validates :secret,  presence: true

  before_validation :generateToken, :on => :create
  before_validation :generateSecret, :on => :create
  before_validation :generateExpireTime, :on => :create

  def expire?
    self.expire_at<Time.now
  end
  
  def generateToken
    self.token = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end

  def generateSecret
    self.secret = Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
  end
  
  def generateExpireTime
    self.expire_at = Time.now+1.month
  end
  
end
