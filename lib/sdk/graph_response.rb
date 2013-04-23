require_relative 'sdk_component.rb'
require_relative 'sdk_exception.rb'
require 'json'
require 'uri'
require 'rack'

class GraphResponse < SDKComponent
	attr_accessor :request
	attr_accessor :response
	attr_accessor :data
	attr_accessor :error
	attr_accessor :paging
	
	def initialize response, request
		@request = request
		@response = response
		if !response.is_a?(Hash)
			response = {"data" => response}
		end
		
		if response["data"].nil?
			@data = response
		else
			@data = response["data"]
		end
		if !response["error"].nil? 
			@error = SDKException.new "Exception from "+request.effective_url+": "+response["error"]["message"]
		end
		@paging = response["paging"]
	end
	
	def next
		self.iterate @paging['next']
	end
	
	def previous
		self.iterate @paging['previous']
	end
	
	def iterate url
		if url
			url = URI(URI.encode url)
			params = Rack::Utils.parse_nested_query(url.query)
			GraphRequest.new(url.path, params).get_response
		end
	end
end