require './lib/version'
Gem::Specification.new do |s|
  s.name        = 'goplay-publisher-sdk'
  s.version     = GoplayPublisherSDK::VERSION
  s.date        = '2013-04-23'
  s.summary     = "A fluent SDK for retrieving Publisher information from the GoPlay graph."
  s.description = "A fluent SDK for retrieving Publisher information from the GoPlay graph."
  s.authors     = ["Keith Nordstrom"]
  s.email       = 'keith@goplay.com'
  s.files       = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
	s.add_runtime_dependency 'cacert'
	s.homepage    = 'http://rubygems.org/gems/publisher-sdk'
end