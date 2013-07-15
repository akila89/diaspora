module Authenticator
  def manifestVerified access_req
    Workers::PostToApp.perform_async(access_req.callback, {:auth_token => access_req.auth_token})
  end
  
  def sendRefreshToken refresh_token, callback
    #TODO send encrypted refresh token and secret
    Workers::PostToApp.perform_async(callback, {:refresh_token => refresh_token.token})
  end
end  
