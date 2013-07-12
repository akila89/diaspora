class ManifestController < ApplicationController
  
  def index
    
  end
  
  def sign    
    mnfst = {"dev_id" => "dilma@localhost:3000"} # Testing 
    private_key = current_user.serialized_private_key
    res = Manifest.new.sign(mnfst,private_key)
    Rails.logger.info("Content: for #{res}")  
  end

  def verify
    mnfst = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJkZXZfaWQiOiJkaWxtYUBsb2NhbGhvc3Q6MzAwMCJ9.ZG37DRVgcf88hFP-TEr6-iDGoZXNbumttL
rvxGxkIsdjIc-Zo2aqFKaWDPMS9xwnw4erV5zTy5p9Cc1L1lSxnvHewZhCa9qr8ffRG-uf4SO9XbMZEPxKc7MscyTKoP8zvUKcxJAa5xhLRXH2aHYCTSH7mKVbbFZTp8_
6ykjwl87H65_gaEPoDyG2kvj4s3CfIiXZ7HwK8irbH0Re9C1SwPNtim_csZk_t8vyUsFXL1SBjWXOgbp28TTJQuZuvBYBu5Az0u3YODyOi9WwMaE3n6i21c6uKEH5a0t7
pWYoqqypdEbsO1yNk0g5d6v4lB096dQi5LVt3uOp0w_70kY2ms0HKw68qo9tQREuld4EbIKrj9I5W8qa5GpIu5FMl46Fd0mihUDE5ey3UnyfEfG95uTyFJrhhnPNZbRWh
bPct85Z4UfQrnSBjeh9_CbHcsLE8LgLqWlrEteaClK3WjENWuqTpJweH6QLcV2JUGYSsem2CQyXVNmGl0wHmeurev0DEKccG7VjIp2QtLY8mSrY6vFAbSIhfKMmnoA89F
FIL0uW2B3zksBhwo9Z9159w8Z0GalAHOb3EhmVN76Xayog-yA0_tEprrB-wwEGp1LSzONr7NWPhg19d7BBKnNGLXtBOVQsgM63ypF6dK9e1nP40yqE8GyPlJ5U_TUH4sY
Y5eUa"
begin 
  res = Manifest.new.verify(mnfst)
rescue => e
  Rails.logger.info("Error occured #{e.message}")
end
    if res
      @css_framework = :bootstrap # Hack, port site to one framework
      render file: Rails.root.join("public", "default.html"),
             layout: 'application'
    end
  end
  
end
