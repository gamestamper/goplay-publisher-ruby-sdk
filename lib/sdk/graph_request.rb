require_relative 'sdk_component.rb'
require 'json'
require 'cacert'
require 'net/https'

class GraphRequest < SDKComponent
	attr_accessor 'effective_url'
	@@host = 'https://graph.goplay.com'
	
	def initialize endpoint, params, method='get'
		@endpoint = self.ensure_slash endpoint
		if params.empty?
			@params = {} 
		else 
			@params = params
		end
		@method = method
		@params[:method] = @method
	end
	
	def get_response
		result = self.run
		if result[0]=="{" || result[0] == "["
			_data = JSON.parse result
		else
			_data = self.query_decode result
		end
		GraphResponse.new _data, self
	end
	
	def run	
		params = self.clean_params(@params)
		url = self.make_uri @@host  
		client = Net::HTTP.new url.host, url.port
		client.use_ssl = true
		client.ca_file = Cacert.pem
		req = Net::HTTP::Post.new @endpoint
		req.set_form_data params
		response = client.start {|http| http.request(req) }
		@effective_url = make_uri(@@host, @endpoint, params).to_s
		response.body
	end
	
	def make_uri host, endpoint="", params={}
		url = URI host + endpoint		
		url.query = URI.encode_www_form params
		url
	end
	
	def clean_params params
		p = {}
		params.each { |k,v|  
			if v.is_a?(String)
				p[k.to_s] = v
			else
				p[k.to_s] = v.to_json.to_s
			end
		}
		p
	end

end