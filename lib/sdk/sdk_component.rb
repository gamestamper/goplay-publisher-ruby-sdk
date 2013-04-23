class SDKComponent
	
	def ensure_slash s
		s = s.to_s
		if s.empty?
			s = "" 
		elsif s[0]!='/'
			s = "/"+s
		else
			s
		end
	end
	
	def query_decode strs
		_hash = {}
		for str in strs.split("&")
			s = str.split("=")
			_hash[s[0]]= s[1]
		end
		_hash
	end
end