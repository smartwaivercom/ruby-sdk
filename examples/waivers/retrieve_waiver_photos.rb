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

# The unique ID of the signed waiver to be retrieved
waiver_id='[INSERT WAIVER ID]'

client = SmartwaiverWaiverClient.new(api_key)

begin
  result = client.photos(waiver_id)

  photos = result[:photos]

  puts "Waiver Photos for: #{photos[:title]}"

  photos[:photos].each do |photo|
    puts "#{photo[:photoId]}: #{photo[:date]}"
  end

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue SmartwaiverSDK::RemoteServerError=>rse
  puts "Remote Server error: #{rse.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver retrieval: #{e.message}"
end
