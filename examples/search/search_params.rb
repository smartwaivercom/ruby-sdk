#
# Copyright 2018 Smartwaiver
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

require 'smartwaiver-sdk/search_client'

# The API Key for your account
api_key='[INSERT API KEY]'

begin

  client = SmartwaiverSearchClient.new(api_key)


  template_id='[INSERT TEMPLATE ID]'
  results = client.search(template_id)

  # Request all waivers signed for this template after the given date
  # results = client.search(template_id, '2017-01-01 00:00:00')

  # Request all waivers signed for this template with a participant name Kyle
  # results = client.search(template_id, '', '', 'Kyle')

  # Request all waivers signed for this template with a participant name Kyle Smith
  # results = client.search(template_id, '', '', 'Kyle', 'Smith')

  # Request all waivers signed with a participant name Kyle that have been email verified
  # results = client.search(template_id, '', '', 'Kyle', '', true)

  # Request all waivers signed in ascending sorted order
  # results = client.search(template_id, '', '', '', '', '', false)

  # Request all waivers with a primary tag of 'testing'
  # results = client.search(template_id, '', '', '', '', '', true, 'testing')

  search = results[:search]
  # Print out some information about the result of the search
  puts "Search Complete:"
  puts "  Search ID: #{search[:guid]}"
  puts "  Waiver Count: #{search[:count]}"
  puts "  #{search[:pages]} pages of size #{search[:pageSize]}"
  puts ""


rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during queue information: #{e.message}"
end
