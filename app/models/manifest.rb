class Manifest < ActiveRecord::Base
  attr_accessible :app_description, :app_id, :app_ver, :comment_write, :comments_read, :dev_id, :manifest_ver, :post_delete, :post_read, :post_write, :profile_read, :url_err_Oauth, :url_err_login, :url_success
end
