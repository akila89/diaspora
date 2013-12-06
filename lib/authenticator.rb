module Authenticator
  def manifestVerified access_req
    Workers::PostToApp.perform_async(access_req.callback, {:auth_token => access_req.auth_token})
  end
  
  def sendRefreshToken refresh_token, callback, diaspora_handle
	  @URL=callback
	  Rails.logger.info("callback : #{@URL}")
    Workers::PostToApp.perform_async(callback, {:refresh_token => refresh_token.token, :diaspora_id=>diaspora_handle})
  end
end
