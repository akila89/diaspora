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
  
end
