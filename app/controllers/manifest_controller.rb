class ManifestController < ApplicationController
  
  def index
    
  end
  
  def sign    
    mnfst = {"dev_id" => "Madhawa"} # Testing 
    private_key = current_user.serialized_private_key
    res = Manifest.new.sign(mnfst,private_key)
    Rails.logger.info("Content: for #{res}")  
  end

  def verify
    #mnfst = 
  end
  
end
