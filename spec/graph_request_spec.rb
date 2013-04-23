require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GraphRequest do
  before(:each) do
    @graph_request = GraphRequest.new '100001294643267',{:fields=>'id,name'},'get'
  end

	describe "#new" do
		it "should take three parameters and return a GraphRequest" do
			@graph_request.should be_an_instance_of GraphRequest
		end
	end
end

