module Authenticator
  def manifestVerified access_req
    Workers::PostToApp.perform_async(access_req.callback, {:token => access_req.auth_token})
  end
end  
