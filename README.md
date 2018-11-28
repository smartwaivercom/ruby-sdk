![](https://d362q4tvy1elxj.cloudfront.net/header_logoheader.png)
RUBY-SDK
==========

Table of Contents
=================

  * [Table of contents](#table-of-contents)
  * [Installation](#installation)
  * [Getting Started](#getting-started)
    * [Retrieve a Specific Template](#retrieve-a-specific-template)
    * [List all Signed Waivers](#list-all-signed-waivers)
    * [Retrieve a Specific Waiver](#retrieve-a-specific-waiver)
    * [Retrieve Photos on a Waiver](#retrieve-photos-on-a-waiver)
    * [Search For Waivers](#search-for-waivers)
    * [Retrieve/Set Webhook Config](#retrieveset-webhook-configuration)
  * [Exception Handling](#exception-handling)
    * [Status Codes](#status-codes)
  * [Advanced](#advanced)
    * [Authentication](#authentication)

Installation
==========

    gem install smartwaiver-sdk

Alternatively, you may install the SDK from the github repo:

    git clone https://www.github.com/smartwaivercom/ruby-sdk

Getting Started
==========

All that is required to start using the SDK is a Smartwaiver account and the API Key for that account.
In all of the examples you will need to put the API Key into the code wherever it says: `[INSERT API KEY]`

If running the examples from the project without installing the gem, you will need to set the RUBYLIB path.

    export RUBYLIB=/Users/<user_name>/workspace/ruby-sdk/lib/smartwaiver-sdk


It's time to start making requests.
A good first request is to list all waiver templates for your account.
Here is the code to do that:

```ruby
require 'smartwaiver-sdk/template_client'
# The API Key for your account
api_key = '[INSERT API KEY]'

# Set up your Smartwaiver client using your API Key
client = SmartwaiverTemplateClient.new(api_key)

# Now request a list of all the waiver templates
results = client.list
```

That's it! You've just requested all waiver templates in your account.
But, now it's time to do something with them.
Let's loop through those templates and print out the ID and Title of each template:

```ruby
result[:templates].each do |template|
  puts "#{template[:templateId]}: #{template[:title]}"
end
```

Awesome! For more details on all the different properties a waiver template has, check out [template_properties.rb](examples/templates/template_properties.rb)

Now that you've got your first request, check out the sections below to accomplish specific actions.

Retrieve a Specific Template
---------

First let's set up the template client.
Make sure to put in your account's API Key where it says `[INSERT API KEY]`

```ruby
require 'smartwaiver-sdk/template_client'
# The API Key for your account
api_key = '[INSERT API KEY]'

# Set up your Smartwaiver client using your API Key
client = SmartwaiverTemplateClient.new(api_key)
```

Now we can request information about a specific template.
To do this we need the template ID.
If you don't know a template ID for your account, try listing all waiver templates for you account, as shown [here](#getting-started), and copying one of the ID's that is printed out.
Once we have a template ID we can execute a request to get the information about the template:

```ruby
# The unique ID of the template to be retrieved
template_id = '[INSERT TEMPLATE ID]'

# Retrieve a specific template (SmartwaiverTemplate object)
template = client.get(template_id)
```

Now let's print out some information about this template.

```ruby
# Access properties of the template
puts "List single template:"
puts "#{template[:templateId]}: #{template[:title]}"
```

To see all the different properties a waiver template has, check out [template_properties.rb](examples/templates/template_properties.rb)

List All Signed Waivers
----------

First let's set up the basic Smartwaiver waiver client. Make sure to put in your account's API Key where it says `[INSERT API KEY]`

```ruby
require 'smartwaiver-sdk/waiver_client'
# The API Key for your account
api_key = '[INSERT API KEY]'

# Set up your Smartwaiver client using your API Key
client = SmartwaiverWaiverClient.new(api_key)
```

Now we can request signed waivers from your account.

```ruby
# Get a list of summaries of waivers
waiver_summaries = client.list
```

With this done, we can iterate over the returned summaries to see what is stored.
The default limit is 20, which means if you have more than 20 in your account, only the most recent 20 will be returned

```ruby
puts "List all waivers:"
waiver_summaries[:waivers].each do |waiver|
  puts "#{waiver[:waiverId]}: #{waiver[:title]}"
end
```

To see all the different properties a waiver summary has, check out [waiver_summary_properties.rb](examples/waivers/waiver_summary_properties.rb)

Once we have a waiver summary, we can access all the detailed information about the waiver. To do that look [here](#retrieve-a-specific-waiver).

But, we can also restrict our query with some parameters.
For example, what if we only want to return 5 waivers, (the default is 20).
Here is the code to do that:

```ruby
# Set the limit
limit = 5

# Get a list of summaries of waivers
waiver_summaries = client.list(limit)
```

Or what if we only want any waivers that have not been verified (either by email or at the kiosk)?

```ruby
# Set the limit
limit = 5

# Set the verified parameter
verified = false

# Get a list of summaries of waivers
waiver_summaries = client.list(limit, verified)
```

What other parameters can you use? Here is an example using all of them:

```ruby
# An example limiting the parameters
limit = 5                                      # Limit number returned to 5
verified = true                                # Limit only to waivers that were signed at a kiosk or verified over email
template_id = '[INSERT TEMPLATE ID]'           # Limit query to waivers of this template ID
from_dts = '2016-11-01T00:00:00'               # Limit to waivers signed in November of 2016
to_dts = '2016-12-01T00:00:00'

# Get a list of summaries of waivers
waiver_summaries = client.list(limit, verified, template_id, from_dts, to_dts)
```

These examples are also available in [list_all_waivers.rb](examples/waivers/list_all_waivers.rb)

###Parameter Options

| Parameter Name | Default Value | Accepted Values   | Notes                                                                                 |
| -------------- | ------------- | ----------------- | ------------------------------------------------------------------------------------- |
| limit          | 20            | 1 - 100           | Limit number of returned waivers                                                      |
| verified       | null          | true/false/null   | Limit selection to waiver that have been verified (true), not (false), or both (null) | 
| templateId     |               | Valid Template ID | Limit signed waivers to only this template                                            |
| fromDts        |               | ISO 8601 Date     | Limit to signed waivers between from and to dates (requires toDts)                    |
| toDts          |               | ISO 8601 Date     | Limit to signed waivers between from and to dates (requires fromDts)                  |

Retrieve a Specific Waiver
----------

What if we want to retrieve a specific waiver?
All we need for that is a waiver ID.
If you don't have a waiver ID to use, you can get a list of signed waivers in your account [here](#list-all-signed-waivers)

First let's set up the basic Smartwaiver object. Make sure to put in your account's API Key where it says `[INSERT API KEY]`

```ruby
require 'smartwaiver-sdk/waiver_client'
# The API Key for your account
api_key = '[INSERT API KEY]'

# Set up your Smartwaiver client using your API Key
client = SmartwaiverWaiverClient.new(api_key)
```

Now, we can request the information about a specific waiver.
Make sure to put your waiver ID in where it says `[INSERT WAIVER ID]`

```ruby
# The unique ID of the signed waiver to be retrieved
waiver_id = '[INSERT WAIVER ID]'

# Get a specific waiver
result = client.get(waiver_id)
```

The waiver object has many different properties that can be accessed.
For example, we can print out the waiver ID and title of the waiver.

```ruby
# Access properties of waiver
waiver = result[:waiver]
puts "List single waiver:"
puts "#{waiver[:waiverId]}: #{waiver[:title]}"
```

To see a full list of all properties that a waiver object contains, check out [waiver_properties.rb](examples/waivers/waiver_properties.rb)

We can also request that the PDF of the signed waiver as a Base 64 Encoded string be included. Here is the request to do that:

```ruby
# The unique ID of the signed waiver to be retrieved
waiver_id = '[INSERT WAIVER ID]'

pdf = true

# Get the waiver object
result = client.get(waiver_id, pdf)
```

The code provided here is also combined in to one example in [retrieve_single_waiver.rb](examples/waivers/retrieve_single_waiver.rb)

Retrieve Photos on a Waiver
----------

We can also use the API to retrieve any photos taken when the waiver was signed or attached later with the console.
All we need is you're API key and the ID of a signed waiver, which has attached photos.


If you don't have a waiver ID to use, you can get a list of signed waivers in your account [here](#list-all-signed-waivers)

First let's set up the basic Smartwaiver object. Make sure to put in your account's API Key where it says `[INSERT API KEY]`

```ruby
require 'smartwaiver-sdk/waiver_client'

# The API Key for your account
api_key='[INSERT API KEY]'

client = SmartwaiverWaiverClient.new(api_key)
```

Now, we can request the photos on a specific waiver.
Make sure to put your waiver ID in where it says `[INSERT WAIVER ID]`

```ruby
# The unique ID of the signed waiver to be retrieved
waiver_id='[INSERT WAIVER ID]'

result = client.photos(waiver_id)

photos = result[:photos]
```

This photos object has a little meta-data we can print out:

```ruby
# Print a little header
puts "Waiver Photos for: #{photos[:title]}"

photos[:photos].each do |photo|
  puts "#{photo[:photoId]}: #{photo[:date]}"
end
```

The code provided here is also combined in to one example in [retrieve_waiver_photos.rb](examples/waivers/retrieve_waiver_photos.rb)


Search for Waivers
----------

First let's set up the basic Smartwaiver object. Make sure to put in your account's API Key where it says `[INSERT API KEY]`

```ruby
require 'smartwaiver-sdk/search_client'

# The API Key for your account
api_key='[INSERT API KEY]'

client = SmartwaiverSearchClient.new(api_key)
```

Now we can request a search for signed waivers from your account.

```ruby
# Request all waivers signed in 2018
results = client.search('', '2018-01-01 00:00:00')
```

**Note: The search route is a blocking search. Thus, a request to search for large amounts of data can take up to a few seconds.
As such, this route should not be used for anything where real-time performance is important. Instead use the Waivers route.**

This will return a search object containing metadata about the results of our search.
We can easily print out all that information:

```ruby
search = results[:search]
# Print out some information about the result of the search
puts "Search Complete:"
puts "  Search ID: #{search[:guid]}"
puts "  Waiver Count: #{search[:count]}"
puts "  #{search[:pages]} pages of size #{search[:pageSize]}"
```

The server has stored the results of our search request under the GUID given.
We can now loop through the pages and request each page, which will be a list of up to 100 waivers.
For example, if we wanted to created a list of all first names from our search, we would do that like this:

```ruby
# We're going to create a list of all the first names on all the waivers
name_list = [];

pages = search[:pages]
current_page = 0
search_guid = search[:guid]

while current_page < pages
  puts "Requesting page: #{current_page}/#{pages} ..."

  waivers = client.results(search_guid, current_page)

  puts "Processing page: #{current_page}/#{pages} ..."

  waivers[:search_results].each do |waiver|
    name_list.push(waiver[:firstName])
  end

  current_page = current_page + 1
end
```

To see all the different properties a waiver has, check out [waiver_properties.rb](examples/waivers/waiver_properties.rb)

This examples is also available in [basic_search.rb](examples/search/basic_search.rb)

### Search Parameters

We can also restrict our search with more parameters.
For example, what if we only want to return waivers for one of the templates in our account.
Here is the code to do that:

```ruby
# The unique ID of the template to search for

template_id='[INSERT TEMPLATE ID]'

# Request all waivers signed for this template
results = client.search(template_id)
```

Or what if we only want any waivers that have not been verified (either by email or at the kiosk)?

```ruby
# Request all waivers signed that not have been email verified
results = client.search(template_id, '', '', '', '', true)
```

What other parameters can you use? Here are some more examples:

```ruby
# Request all waivers signed for this template after the given date
results = client.search(template_id, '2017-01-01 00:00:00')

# Request all waivers signed for this template before the given date
results = client.search(template_id, '', '2017-01-01 00:00:00')

# Request all waivers signed for this template with a participant name Kyle
results = client.search(template_id, '', '', 'Kyle') 

# Request all waivers signed for this template with a participant name Kyle Smith
results = client.search(template_id, '', '', 'Kyle', 'Smith') 

# Request all waivers signed with a participant name Kyle that have been email verified
results = client.search(template_id, '', '', 'Kyle', '', true) 

# Request all waivers signed in ascending sorted order
results = client.search(template_id, '', '', '', '', '', false)
```

These examples are also available in [search_params.rb](examples/search/search_params.rb)

### Parameter Options

| Parameter Name | Default Value | Accepted Values   | Notes                                                                                   |
| -------------- | ------------- | ----------------- | --------------------------------------------------------------------------------------- |
| templateId     |               | Valid Template ID | Limit signed waivers to only this template                                              |
| fromDts        |               | ISO 8601 Date     | Limit to signed waivers between after this date                                         |
| toDts          |               | ISO 8601 Date     | Limit to signed waivers between before this date                                        |
| firstName      |               | Alpha-numeric     | Limit to signed waivers that have a participant with this first name (Case Insensitive) |
| lastName       |               | Alpha-numeric     | Limit to signed waivers that have a participant with this last name (Case Insensitive)  |
| verified       | null          | true/false/null   | Limit selection to waiver that have been verified (true), not (false), or both (null)   |
| sortDesc       | true          | true/false        | Sort results in descending (latest signed waiver first) order                           |



Retrieve/Set Webhook Configuration
----------

You can both retrieve and set your account's webhook configuration through this SDK with a couple simple calls.
To view your current webhook settings, we first need to set a Smartwaiver object.
Make sure to put in your account's API Key where it says `[INSERT API KEY]`

```ruby
require 'smartwaiver-sdk/webhook_client'
# The API Key for your account
api_key = '[INSERT API KEY]'

# Set up your Smartwaiver client using your API Key
client = SmartwaiverWebhookClient.new(api_key)
```

Now, it's easy to request the webhook configuration:

```ruby
# Get the current webhook settings
result = client.configuration
```

And, now we can print out the information:

```ruby
# Access the webhook config
puts "Endpoint: #{result[:webhooks][:endpoint]}"
puts "EmailValidationRequired: #{result[:webhooks][:emailValidationRequired]}"
```

The Email Validation Required is whether the webhook will fire before, after, or before and after a waiver is verified.
The endpoint is simply the endpoint URL for the webhook.

And changing your webhook configuration is just as easy.
The new configuration will be returned from the request and can be access just like the read request above.

```ruby
# The new values to set
endpoint = 'http://endpoint.example.org'
email_validation_required = SmartwaiverWebhookClient::WEBHOOK_AFTER_EMAIL_ONLY

# Set the webhook to new values
result = client.configure(end_point, send_after_email_only)

# Access the new webhook config
webhook = result[:webhooks]
puts "Successfully set new configuration."
puts "Endpoint: #{webhook[:endpoint]}"
puts "EmailValidationRequired: #{webhook[:emailValidationRequired]}"
```

This code is also provided in [retrieve_webhooks.rb](examples/webhooks/retrieve_webhooks.rb)
and [set_webhooks.rb](examples/webhooks/set_webhooks.rb)

Exception Handling
==========

There are three types of exceptions int the SDK:
 * A <b>BadAPIKeyError</b> occurs if the API key is incorrect or missing.
 * A <b>BadFormatError</b> occurs when trying to update the webhook configuration with incorrect data.
 * All other types of errors will be a <b>RemoteServerError</b> which is thrown by the API server.  The message returned explains the problem.
 
Here is an example of catching an HTTP exception. First we set up the Smartwaiver account:

```ruby
require 'waiver_client'

# The API Key for your account
api_key='[INSERT API KEY]'

# The unique ID of the signed waiver to be retrieved

client = SmartwaiverWaiverClient.new(api_key)
```

Next, we attempt to get a waiver that does not exist:

```ruby
# The Waiver ID to access
waiver_id='InvalidWaiverId'

# Try to get the waiver object
result = client.get(waiver_id)
```

This will throw an exception because a waiver with that ID does not exist. So let's change the code to catch that exception:

```ruby
begin
  # use default parameters
  result = client.get(waiver_id)

  waiver = result[:waiver]
  puts "List single waiver:"
  puts "#{waiver[:waiverId]}: #{waiver[:title]}"

  result = client.get(waiver_id, true)

  waiver = result[:waiver]
  puts "PDF:"
  puts "#{waiver[:pdf]}"

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver retrieval: #{e.message}"
end
```

But there is lot's of useful information in the exception object. Let's print some of that out too:

```ruby
# The code will be the HTTP Status Code returned
puts "Error Message: #{e.message}"

# Also included in the exception is the header information returned about
# the response.
puts "API Version: #{e.result[:version]}"
puts "UUID: #{e.result[:id]}"
puts "Timestamp: #{e.result[:ts]}"
```

Status Codes
----------

The code of the exception will match the HTTP Status Code of the response and the message will be an informative string informing on what exactly was wrong with the request.

Possible status codes and their meanings:

| Status Code | Error Name            | Description                                                                                                                       |
| ----------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| 400         | Parameter Error       | Indicates that something was wrong with the parameters of the request (e.g. extra parameters, missing required parameters, etc.). |
| 401         | Unauthorized          | Indicates the request was missing an API Key or contained an invalid API Key.                                                     |
| 402         | Data Error            | Indicates that the parameters of the request was valid, but the data in those parameters was not.                                 |
| 404         | Not Found             | Indicates that whatever was being searched for (specific waiver, etc.) could not be found.                                        |
| 406         | Wrong Content Type    | Indicates that the Content Type of the request is inappropriate for the request.                                                   |
| 500         | Internal Server Error | Indicates that the server encountered an internal error while processing the request.                                             |

Advanced
==========

This section contains notes about several more ways to use the SDK that are slightly more low level.


Authentication
----------

If you are making custom requests you must include the proper authentication.
The Smartwaiver API expects a header called 'sw-api-key' to contain the API for the account you are accessing.

    sw-api-key: [INSERT API KEY]

If you do not have a Smartwaiver API key go [here](https://www.smartwaiver.com/p/API) to find out how to create one. 
