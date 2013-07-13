class Dauth::AllowedApps < ActiveRecord::Base
  
  attr_accessible :app_home_page_url, 
                  :app_id, 
                  :app_name, 
                  :callback, 
                  :dev_handle, 
                  :discription, 
                  :manifest
  
  validates :app_id,  presence: true, uniqueness: true
  validates :manifest,  presence: true
  validates :app_home_page_url,  presence: true
                  
  
end
