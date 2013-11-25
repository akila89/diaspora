class ManifestsController < ApplicationController
  before_filter :authenticate_user!
  ALL_SCOPES = ["post_write", "post_read", "post_delete", "comment_write", "comment_read", "profile_read", "friend_list_read"]

  def index
    @manifests = Manifest.where(dev_id:current_user.diaspora_handle)
  end

  def show
    @scopes = ALL_SCOPES
    @manifest = Manifest.find(params[:id])
  end

  def new
    @scopes = ALL_SCOPES
    @manifest = Manifest.new
  end

  def create
    @scopes = ALL_SCOPES
    @manifest = Manifest.new(params[:manifest])
    @manifest.dev_id = current_user.diaspora_handle
    @manifest.app_id = get_app_id
    if @manifest.save   
      render "show"
    else
      render "new"
      flash[:notice] = t("manifests.missing_values")
    end
  end

  def update
    @manifest = Manifest.find(params[:id])
    @scopes = ALL_SCOPES

    if @manifest.update_attributes(params[:manifest])
      redirect_to @manifest
      flash[:notice] = t("manifests.successfully_updated")
    else
      render action: "show"
    end
  end

  def destroy
    @manifest = Manifest.find(params[:id])
    @manifest.destroy
    redirect_to manifests_url
  end

  def download
    manifest = Manifest.find(params[:id])
    manifest.sign current_user.serialized_private_key
    send_data manifest.create_manifest_json, :filename => "#{manifest.app_name}.json", :type => :json
  end

  private

  def get_app_id
    # Assign an app id that should be unique.  
    stamp = Time.now.to_i
    random = Random.new.rand(1..60)
    "#{random}#{stamp}"
  end
end
