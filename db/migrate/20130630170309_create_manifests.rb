class CreateManifests < ActiveRecord::Migration
  def change
    create_table :manifests do |t|
      t.string :dev_id
      t.string :app_id
      t.string :app_description
      t.string :app_name
      t.string :app_version
      t.string :manifest_ver
      t.string :callback
      t.string :redirect
      t.text :signed_jwt
      t.text :scopes

      t.timestamps
    end
  end
end
