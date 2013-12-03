class CreateDauthRefreshTokens < ActiveRecord::Migration
  def change
    create_table :dauth_refresh_tokens do |t|
      t.string :token
      t.string :secret
      t.string :app_id
      t.string :user_id
      t.text :scopes

      t.timestamps
    end
    
    add_index :dauth_refresh_tokens, [:app_id, :user_id], :unique => true
    
  end
end
