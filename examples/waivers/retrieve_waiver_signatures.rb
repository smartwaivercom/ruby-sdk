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
  result = client.signatures(waiver_id)

  signatures = result[:signatures]

  puts "Waiver Signatures for: #{signatures[:title]}"

  signature_data = signatures[:signatures]
  signature_data[:participants].each do |sig|
    puts "Participant #{sig}"
  end

  signature_data[:guardian].each do |sig|
    puts "Guardian #{sig}"
  end

  signature_data[:bodySignatures].each do |sig|
    puts "Body Signatures #{sig}"
  end

  signature_data[:bodyInitials].each do |sig|
    puts "Body Initials #{sig}"
  end

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue SmartwaiverSDK::RemoteServerError=>rse
  puts "Remote Server error: #{rse.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver retrieval: #{e.message}"
end
