
class DevelopersController < ApplicationController
 #include Diaspora::EncryptManifest

   def developer
	
   end
   def show

   end
   def update
	@developer_id=current_user.diaspora_handle
	@app_ID= ""
      if u = params[:developer]
        if u[:app_name]
            @app_name=u[:app_name]
	end
        if u[:app_discription]
	    @app_discription=u[:app_discription]
	end
        if u[:app_version]
	    @app_version=u[:app_version]
	end
	if u[:success]
	    @success_url=u[:success]
	end
	if u[:error_login]
	    @error_login=u[:error_login]
	end
	if u[:error_auth]
	    @error_authurl=u[:error_auth]
	end
	if u[:post_read]
	    if u[:post_read]=='1'
	    @post_read=true
            else
	    @post_read=false
	    end
	end
	if u[:post_write]
	    if u[:post_read]=='1'
	    @post_write=true
            else
	    @post_write=false
	    end
	end
	if u[:post_delete]
	    if u[:post_read]=='1'
	    @post_delete=true
            else
	    @post_delete=false
	    end
	end
	if u[:comment_read]
	    if u[:comment_read]=='1'
	    @comment_read=true
            else
	    @comment_read=false
	    end
	end
	if u[:comment_write]
	    if u[:comment_read]=='1'
	    @comment_write=true
            else
	    @comment_write=false
	    end
	end
	if u[:comment_delete]
	    if u[:comment_read]=='1'
	    @comment_delete=true
            else
	    @comment_delete=false
	    end
	end
	self.createMenifestJson @developer_id, @app_ID, @app_discription, @app_version, @success_url,@error_login,@error_authurl,@post_read, @post_write, @post_delete,@comment_read, @comment_write, @comment_delete 
      end
      redirect_to developer_path
   end 

   def createMenifestJson dev_id, app_id, app_discription, app_version, success_url, error_login, error_auth, post_read, post_write,post_delete,comment_read, comment_write, comment_delete
		menifest={ 

		:DeveloperDetails=>{
			:ID=> dev_id
			},
		:AppDetails=>{
	      		:ID=> app_id,
	                :Discription=>app_discription,
	                :Version=>app_version,
			:ManifestVersion=>""
	                },
		:URLs=>{
			:success=>success_url,
			:ErrorLogin=>error_login,
			:ErrorAuth=>error_auth
			},
		:Access=>{
			:Post=>{
			:read=>post_read,
			:write=>post_write,
			:delete=>post_delete
	    		},
			:ProfileDetails=>{
			:read=>""
	        	},
			:Comments=>{
			:read=>comment_read,
			:write=>comment_write,
			:delet=>comment_delete
			}
	
		},
		:Permissions=>{
			
			},
	}
        #message=self.encodeJson "asda", menifest.to_json
	#flash[:notice] = menifest.to_json
	flash[:notice]=encodeMenifest menifest.to_json
	end
	
	#Encode Menifest
	def encodeMenifest menifetJson
 		jsonContent = JSON.parse(menifetJson)
		encodedJsonObject = JWT.encode(jsonContent, OpenSSL::PKey::RSA.new(current_user.serialized_private_key),"RS256")
		decodedJsonObject=JWT.decode(encodedJsonObject, OpenSSL::PKey::RSA.new(current_user.person.public_key),"RS256")
		decodedJsonObject
		#OpenSSL::PKey::RSA.new(serialized_private_key)
        end
end
