class AddRedirectUrlToManifest < ActiveRecord::Migration
  def change
    add_column :manifests, :redirect, :string
  end
end
