class ManifestController < ApplicationController
  
  def index
    
  end
  
  def sign    
    mnfst = {"Hellp" => "Madhawa"} # Testing 
    private_key = current_user.serialized_private_key
    res = Manifest.new.sign(mnfst,cinnum)
    Rails.logger.info("Content: for #{res}")  
  end

  def verify
    
  end
  
end
