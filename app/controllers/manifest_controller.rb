class ManifestController < ApplicationController
  
  def index
    
  end
  
  def sign    
    mnfst = {"Hellp" => "Madhawa"}
    manifest = Manifest.new
    res=manifest.sign(mnfst)
    Rails.logger.info("Content: for #{res}")  
  end

  def verify
    
  end
  
end
