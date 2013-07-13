class Dauth::AccessRequest < ActiveRecord::Base
  serialize :scopes, Array

  attr_accessible :auth_token,
                  :callback,
                  :dev_handle,
                  :scopes

  validates :auth_token,  presence: true, uniqueness: true
  validates :callback,  presence: true
  validates :scopes,  presence: true
end
