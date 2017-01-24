#
# Copyright 2017 Smartwaiver
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

require 'smartwaiver-sdk/waiver_client'

# The API Key for your account
api_key='[INSERT API KEY]'

client = SmartwaiverWaiverClient.new(api_key)

begin
  # use default parameters
  result = client.list

  puts "List all waivers:"
  result[:waivers].each do |waiver|
    puts "#{waiver[:waiverId]}: #{waiver[:title]}"
  end

  # Specifiy non default parameters
  limit = 5
  verified = true
  template_id = "586ffe15134bd"
  from_dts = '2017-01-01T00:00:00Z'
  to_dts = '2017-02-01T00:00:00Z'

  result = client.list(limit, verified, template_id, from_dts, to_dts)

  puts "List all waivers:"
  result[:waivers].each do |waiver|
    puts "#{waiver[:waiverId]}: #{waiver[:title]}"
  end

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver listing: #{e.message}"
end
