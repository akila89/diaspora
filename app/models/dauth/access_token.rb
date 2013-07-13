class Dauth::AccessToken < ActiveRecord::Base
  attr_accessible :refresh_token, 
                  :secret, 
                  :token
                  
  validates :refresh_token,  presence: true, uniqueness: true
  validates :token,  presence: true
  validates :secret,  presence: true
end
