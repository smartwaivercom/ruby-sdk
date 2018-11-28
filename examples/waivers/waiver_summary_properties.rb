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

require 'smartwaiver-sdk/waiver_client'

# The API Key for your account
api_key='[INSERT API KEY]'

client = SmartwaiverWaiverClient.new(api_key)

begin
  result = client.list
  if result[:waivers].length > 1
    waiver = result[:waivers][0]
    puts "Waiver ID: #{waiver[:waiverId]}"
    puts "Template Id: #{waiver[:templateId]}"
    puts "Title: #{waiver[:title]}"
    puts "Created On: #{waiver[:createdOn]}"
    puts "Expiration Date: #{waiver[:expirationDate]}"
    puts "Expired: #{waiver[:expired]}"
    puts "Verified: #{waiver[:verified]}"
    puts "Kiosk: #{waiver[:kiosk]}"
    puts "First Name: #{waiver[:firstName]}"
    puts "Middle Name: #{waiver[:middleName]}"
    puts "Last Name: #{waiver[:lastName]}"
    puts "Dob: #{waiver[:dob]}"
    puts "Is Minor: #{waiver[:isMinor]}"
    puts "Tags: #{waiver[:tags]}"
  end

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver summary: #{e.message}"
end
