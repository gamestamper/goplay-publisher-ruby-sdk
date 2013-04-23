require 'test/unit'
require 'publisher_s_d_k_spec'
require 'spec_helper'

class PublisherSDKSpec < Test::Unit::TestCase

	describe PublisherSDK do
		before :each do
				@publisher_sdk = PublisherSDK.new "pbgspub", "a8sdfjweuy3456"
		end
		
		describe "#new" do
			it "takes two parameters and returns a PublisherSDK" do
				@publisher_sdk.should be_an_instance_of PublisherSDK
			end
		end
		
		describe "#magic_methods" do
			it "should understand pub as the pubId" do
				@publisher_sdk.pub.endpoint.to_s.should eql "/pbgspub"
			end
		end
		
		describe "#magic_methods" do
			it "should understand publisher as the pubId" do
				@publisher_sdk.publisher.endpoint.to_s.should eql "/pbgspub"
			end
		end
		
		describe "#magic_methods" do
			it "should update its endpoint via nesting function calls" do
				@publisher_sdk.pub.something.endpoint.to_s.should eql "/pbgspub/something"
			end
		end

		describe "#get_token" do
			it "returns a token when asked" do
				token = @publisher_sdk.get_token
				token.should be_an_instance_of String		
			end
		end
		
		describe "#make_graph_request" do
			it "returns a graph response object with data" do
				resp = @publisher_sdk.pub.make_graph_request nil, 'get'
				resp.should be_an_instance_of GraphResponse
				resp.error.should eql nil
				resp.data.should_not eql nil
				resp.data["gstype"].should eql "Publisher"
			end
		end
		
		describe "#get" do
			it "gets responses for various queries" do
				resp = @publisher_sdk.pub.get
				resp.data["gstype"].should eql "Publisher"
				
				resp = @publisher_sdk.get "pbgspub"
				resp.data["gstype"].should eql "Publisher"
			end
		end
		
		describe "#post" do
			it "posts values and returns them for various queries" do			
				resp = @publisher_sdk.pub.playersclub.account1.delete 
				
				resp = @publisher_sdk.pub.playersclub.get
				count = resp.data.count
				
				players = {:players=>{:first=>{:email=>'a@b.com',:birthday=>'6/26/1971',:accountId=>'account1'}}}
				resp = @publisher_sdk.pub.playersclub.post players
				resp.data["first"].should_not eql nil
				
				resp = @publisher_sdk.get resp.data["first"]
				resp.data["email"].should eql 'a@b.com'
				
				resp = @publisher_sdk.pub.playersclub.account1.get
				resp.data["email"].should eql 'a@b.com'
				
				resp = @publisher_sdk.pub.playersclub.get
				resp.data.count.should eql count+1			
				
				# this does not post a new one because the account id is identical
				players = {:players=>[{:email=>'a@b.com',:birthday=>'6/26/1971',:accountId=>'account1'}]}
				resp = @publisher_sdk.pub.playersclub.post players

				resp = @publisher_sdk.pub.playersclub.get
				resp.data.count.should eql count+1			
			end
		end
		
		describe "#delete" do
			it "deletes posts directly" do
				players = {:players=>[{:email=>'a@b.com',:birthday=>'6/26/1971',:accountId=>'account1'}]}
				resp = @publisher_sdk.pub.playersclub.post players
				
				resp = @publisher_sdk.pub.playersclub.get
				resp.data.each{|v| @publisher_sdk.delete v["id"]}
				
				resp = @publisher_sdk.pub.playersclub.get
				resp.data.count.should eql 0
			end
		end

		describe "GraphRequest#paging" do
			it "pages up and down" do
				resp = @publisher_sdk.pub.playersclub.get
				resp.data.each{|v| @publisher_sdk.delete v["id"]}
				
				recs = []
				7.times do |n| 
					recs[n] = {:email=>'a'+n.to_s+'@b.com',:birthday=>'6/26/1971',:accountId=>'account'+n.to_s}
				end
				players = {:players=>recs}
				resp = @publisher_sdk.pub.playersclub.post players

				params = {:limit=>5}
				resp = @publisher_sdk.pub.playersclub.get params
				resp.data.count.should eql 5

				resp.previous.should eql nil
				resp.next.data.count.should eql 2
				resp.next.next.data.count.should eql 0
				resp.next.previous.data.count.should eql 5
			end
		end
	end
end
