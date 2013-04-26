GoPlay Publisher Ruby SDK
========================

Our Publisher Ruby SDK lets you access our Graph API in as little as one line.

You can download the [GoPlay Publisher Ruby SDK](https://github.com/gamestamper/goplay-publisher-ruby-sdk) from 
GitHub [here](https://github.com/gamestamper/goplay-publisher-ruby-sdk).

* * *

## Installing and Initializing

The gem is registered with rubygems.org.  So installation is simply:

<div class="preWide"><pre>
gem install goplay-publisher-sdk
</pre></div>

Use the SDK by instantiating a new `PublisherSDK` object with your Publisher ID and Publisher Secret.

<div class="preWide"><pre>
@sdk = PublisherSDK.new "YOUR_PUBLISHER_ID", "YOUR_PUBLISHER_SECRET"
</pre></div>

* * *

## Getting Data

To get data from the Graph, you have a few options, depending on your preference. Let's say that you want to 
retrieve your Player's Club data.  This data lives at the following location on our graph: https://graph.goplay.com/[publisher_id]/playersClub. 
All of the following calls return the same result:

<div class="preWide"><pre>
@sdk = PublisherSDK.new "YOUR_PUBLISHER_ID", "YOUR_PUBLISHER_SECRET"

// the standard way
@response = @sdk.get "[publisher_id]/playersClub"

// but it's nicer not repeat your publisher_id
@response = @sdk.publisher.playersClub.get

// and it's even better to not have to type as much
@response = @sdk.pub.playersClub.get
</pre></div>

### Understanding the Response

The response that is returned has a few properties to simplify things a bit, most notably `data` and `error`.

<div class="preWide"><pre>
// get some data
@response = @sdk.pub.playersClub.get

if @response.error
  print @response.error.message
else
  // do something with the data
  print @response.data.count
end
</pre></div>

### Passing parameters

There are times when there are parameters you might want to pass, such as limit and fields, which work as follows:

<div class="preWide"><pre>
// the standard way
@response = @sdk.get '[publisher_id]/playersClub', {'limit':10, 'fields':'email'}

// short-hand
@response = @sdk.pub.playersClub.get {'limit':10, 'fields':'email'}
</pre></div>

### Paging

To iterate through pages of data, use the `next()` and `previous()` functions:

<div class="preWide"><pre>
// get the data
@response = @sdk.pub.playersClub.get {'limit'=>10}

// get the next page
@nextPage = @response.next

// get the previous page
@previousPage = @response.previous
</pre></div>

* * *

## Posting Data

Posting to the Graph API works almost identically to how getting data works. Instead of calling `get`, we instead 
call `post`. The following shows how to post some data (in this case users) to the graph:

<div class="preWide"><pre>
@sdk = PublisherSDK.new "YOUR_PUBLISHER_ID", "YOUR_PUBLISHER_SECRET"

@users = [
	{
		'accountId':'act123', 'email':'abc@def.com', 
		'zip':'12345', 'birthday':'01/01/1970'
	},
	{
		'accountId':'act456', 'email':'def@ghi.com', 
		'zip':'67890', 'birthday':'01/01/1971'
	}
];

// the standard way
@response = @sdk.post '[publisher_id]/playersClub', {'players':@users}

// shorter with no publisher_id
@response = @sdk.publisher.playersClub.post {'players':@users}

// even shorter
@response = @sdk.pub.playersClub.post {'players':@users}
</pre></div>

* * *

## Deleting Data

Though rare, there are times when you might need to delete data from our Graph API. Once again, the SDK offers the same 
flexibility. We'll delete some data in a few ways:

<div class="preWide"><pre>
// assumes we have three accounts with accountIds 'act123', 'act456', and 'act789'

// remove one the standard way
@response = @sdk.delete '[publisher_id]/playersClub', array('accountId'=>'act123')

// remove another a different way
@response = @sdk.pub.playersClub.delete array('accountId'=>'act456')

// remove the last in yet another way
@response = @sdk.pub.playersClub.act789.delete()
</pre></div>
