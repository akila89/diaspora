class Dauth::ThirdpartyApp < ActiveRecord::Base

  belongs_to :user

  attr_accessible :user_id,
                  :app_id,
                  :app_name,
                  :description,
                  :dev_handle,
                  :homepage_url

end
