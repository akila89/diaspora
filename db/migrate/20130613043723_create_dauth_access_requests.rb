class CreateDauthAccessRequests < ActiveRecord::Migration
  def change
    create_table :dauth_access_requests do |t|
      t.string :auth_token, :unique => true, :null => false
      t.string :dev_handle, :null => false
      t.string :callback, :null => false
      t.text :scopes

      t.timestamps
    end
  end
end
