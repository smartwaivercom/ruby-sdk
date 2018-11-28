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

  puts "Performing search for all waiver signed after 2018-01-01 00:00:00..."

  # Request all waivers signed in 2018
  results = client.search('', '2018-01-01 00:00:00')

  search = results[:search]
  # Print out some information about the result of the search
  puts "Search Complete:"
  puts "  Search ID: #{search[:guid]}"
  puts "  Waiver Count: #{search[:count]}"
  puts "  #{search[:pages]} pages of size #{search[:pageSize]}"
  puts ""


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

  puts "Finished processing..."

  puts name_list.join(',')

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during queue information: #{e.message}"
end
