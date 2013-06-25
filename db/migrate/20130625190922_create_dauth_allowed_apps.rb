class CreateDauthAllowedApps < ActiveRecord::Migration
  def change
    create_table :dauth_allowed_apps do |t|
      t.string :app_id
      t.string :app_name
      t.string :discription
      t.string :app_home_page_url
      t.string :dev_handle
      t.text :manifest
      t.string :callback

      t.timestamps
    end
  end
end
