class AddRedirectUrlToDauthAccessRequests < ActiveRecord::Migration
  def change
    add_column :dauth_access_requests, :redirect_url, :string
  end
end
