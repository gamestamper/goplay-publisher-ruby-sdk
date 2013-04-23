require_relative 'graph_request'
require_relative 'graph_response'
class PublisherSDK < SDKComponent
	attr_accessor :endpoint
	
	def initialize pub_id, secret
		@pub_id = pub_id.to_s
		@secret = secret.to_s
		@endpoint = ""
	end
	
	def method_missing name, *args
		name = name.to_s
		if name=='pub' || name=='publisher'
			@endpoint += self.ensure_slash @pub_id
			return self
		else
			@endpoint += self.ensure_slash name
			return self
		end
		super
	end
	
	def get_token
		if !self.get_stored_token
			@token = self.get_token_from_server
		end
		return @token
	end
	
	def get_stored_token
		if !@token
			#add storage in cache?
		end
		return @token
	end
	
	def get_token_from_server
		req = GraphRequest.new 'oauth/access_token', {:client_id => @pub_id, :client_secret=>@secret, :grant_type=> 'publisher_credentials'}
		req.get_response.response["access_token"]
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
			@endpoint = arg1
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
		endpoint = @endpoint
		@endpoint = ""
		resp = self.handle_response(GraphRequest.new(endpoint, params, method).get_response)
	end
	
	def handle_response response
		if !response.error.nil?
			raise response.error
		end
		return response
	end
	
end