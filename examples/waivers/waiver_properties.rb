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
  result = client.get(waiver_id, true)

  waiver = result[:waiver]
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
  puts "Tags: "
  waiver[:tags].each do |tag|
    puts "    #{tag}"
  end

  puts "Participants:"
  waiver[:participants].each do |p|
    puts "    First Name: #{p[:firstName]}"
    puts "    Middle Name: #{p[:middleName]}"
    puts "    Last Name: #{p[:lastName]}"
    puts "    DOB: #{p[:dob]}"
    puts "    Is Minor: #{p[:isMinor]}"
    puts "    Gender: #{p[:gender]}"
    puts "    Tags: #{p[:tags]}"
    puts "    Custom Participant Fields: (GUID, Display Text, Value)"
    p[:customParticipantFields].each do |k,v|
      puts "        #{k}, #{v[:value]}, #{v[:displayText]}"
    end

  end

  puts "Custom Waiver Fields: (GUID, Display Text, Value)"
  waiver[:customWaiverFields].each do |k,v|
    puts "    #{k}, #{v[:value]}, #{v[:displayText]}"
  end

  puts "Email: #{waiver[:email]}"
  puts "Marketing Allowed: #{waiver[:marketingAllowed]}"
  puts "Address Line One: #{waiver[:addressLineOne]}"
  puts "Address Line Two: #{waiver[:addressLineTwo]}"
  puts "Address City: #{waiver[:addressCity]}"
  puts "Address State: #{waiver[:addressState]}"
  puts "Address Zip Code: #{waiver[:addressZipCode]}"
  puts "Address Country: #{waiver[:addressCountry]}"
  puts "Emergency Contanct Name: #{waiver[:emergencyContactName]}"
  puts "Emergency Contanct Phone: #{waiver[:emergencyContactPhone]}"
  puts "Insurance Carrier: #{waiver[:insuranceCarrier]}"
  puts "Insurance Policy Number: #{waiver[:insurancePolicyNumber]}"
  puts "Drivers License Number: #{waiver[:driversLicenseNumber]}"
  puts "Drivers License State: #{waiver[:driversLicenseState]}"
  puts "Client IP: #{waiver[:clientIP]}"
  puts "PDF: #{waiver[:pdf]}"

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver properties: #{e.message}"
end
