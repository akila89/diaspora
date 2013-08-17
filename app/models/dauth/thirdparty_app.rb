class Dauth::ThirdpartyApp < ActiveRecord::Base
  attr_accessible :app_id, 
                  :description,
                  :dev_handle,
                  :homepage_url,
                  :name
end
