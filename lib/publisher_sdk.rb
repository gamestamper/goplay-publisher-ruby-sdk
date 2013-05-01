require_relative 'graph_request'
require_relative 'graph_response'
require 'digest/md5'
class PublisherSDK < SDKComponent
	attr_accessor :endpoint, :token
	ALLOWED_FAILURES = 2
	@@token_cache = {}
	def initialize pub_id, secret, is_test = false
		@pub_id = pub_id.to_s
		@secret = secret.to_s
		@cache_key = Digest::MD5.hexdigest @pub_id + '-' + @secret
		@endpoint = ""
		SDKHost::test? is_test
	end
	
	def method_missing name, *args
		name = name.to_s
		if name=='pub' || name=='publisher'
			return extend_endpoint @pub_id
		else
			return extend_endpoint name
		end
		super name, *args
	end
	
	def extend_endpoint endpoint
		result =  PublisherSDK.new @pub_id,@secret
		result.endpoint = @endpoint + self.ensure_slash(endpoint)
		result
	end
	
	def get_token
		if !self.get_stored_token
			self.get_token_from_server
		end
		return get_stored_token
	end
	
	def set_stored_token token, failures = 0
		@@token_cache[@cache_key] = {:token => token, :failures => failures}
	end
	
	def get_stored_token
		return self.get_stored_token_object[:token]
	end
	
	def get_stored_token_object
		return @@token_cache[@cache_key] ? @@token_cache[@cache_key] : {:token => nil, :failures => 0}
	end
	
	def get_token_from_server
		req = GraphRequest.new 'oauth/access_token', {:client_id => @pub_id, :client_secret=>@secret, :grant_type=> 'publisher_credentials'}
		set_stored_token req.get_response.response['access_token']
		get_stored_token
	end
	
	def get arg1=nil, arg2=nil
		self.construct_request 'get', arg1, arg2
	end
	
	def post arg1=nil, arg2=nil
		self.construct_request 'post', arg1, arg2
	end
	
	def delete arg1=nil, arg2=nil
		self.construct_request 'delete', arg1, arg2
	end
	
	def construct_request method, arg1, arg2
		if arg1.is_a? String
			@endpoint += self.ensure_slash arg1
			self.make_graph_request arg2, method
		else
			self.make_graph_request arg1, method
		end
	end
	
	def make_graph_request params, method
		if params.nil?
			params = {}
		end
		params[:access_token] = self.get_token	
		self.handle_response(GraphRequest.new(@endpoint, params, method).get_response)
	end
	
	def handle_response response
		if !response.error.nil?
			if response.error.code==190
				return self.retry_request_with_new_token response
			else
				self.clear_token_failures
				raise response.error
			end
		end
		@endpoint = ""
		self.clear_token_failures
		response
	end

	def fail_token
		t = self.get_stored_token_object
		self.set_stored_token t[:token], t[:failures]+1
	end
	
	def clear_token_failures
		self.set_stored_token self.get_stored_token
	end
	
	def get_token_failures
		t = self.get_stored_token_object
		t[:failures]
	end
	
	def retry_request_with_new_token resp
		self.fail_token
		if self.get_token_failures <= PublisherSDK::ALLOWED_FAILURES
			req = resp.request
			req.params[:access_token] = self.get_token_from_server
			return self.handle_response req.get_response
		end
		raise resp.error
	end

end