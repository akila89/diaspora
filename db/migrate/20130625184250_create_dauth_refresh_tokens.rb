class CreateDauthRefreshTokens < ActiveRecord::Migration
  def change
    create_table :dauth_refresh_tokens do |t|
      t.string :token
      t.string :secret
      t.string :app_id
      t.string :user_guid
      t.text :scopes

      t.timestamps
    end
  end
end
