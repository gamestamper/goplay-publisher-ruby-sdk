class SDKException < Exception
	attr_accessor 'code','message','type','url'
	
	def initialize message, code, type, url
		@message = message
		@code = code
		@type = type
		@url = url
	end
end
