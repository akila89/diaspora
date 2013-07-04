require "jwt"
require 'json'
require 'pp'
module Diaspora
module EncryptManifest

	def encodeJson dev_private_key
		#Read the json object
		json = File.read('./menifest.json')
		jsonContent = JSON.parse(json)

		#pp json      # pritty print output

		#Encode json object using developer's private key
		encodedJsonObject=JWT.encode(jsonContent, dev_private_key)
		pp encodedJsonObject   
	end

	def decodeJson
		decodedJsonObject=JWT.decode(encodedJsonObject, "secret")
		pp decodedJsonObject      # pritty print output of decoded Json Object
	end

        def encodeMenifest
		json='{ }'
 		jsonContent = JSON.parse(json)
		encodedJsonObject=JWT.encode(jsonContent, "asd")
		pp encodedJsonObject
        end
end
end
