class CreateManifests < ActiveRecord::Migration
  def change
    create_table :manifests do |t|
      t.string :dev_id
      t.string :app_id
      t.string :app_description
      t.string :app_ver
      t.string :manifest_ver
      t.string :url_success
      t.string :url_err_login
      t.string :url_err_Oauth
      t.boolean :post_read
      t.boolean :post_write
      t.boolean :post_delete
      t.boolean :profile_read
      t.boolean :comments_read
      t.boolean :comment_write

      t.timestamps
    end
  end
end
