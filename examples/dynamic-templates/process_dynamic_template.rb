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


# Process Dynamic Template Sample Code
#
# export RUBYLIB=<path>/sw-sdk-ruby/lib
#

require 'smartwaiver-sdk/dynamic_template'
require 'smartwaiver-sdk/dynamic_template'
require 'smartwaiver-sdk/dynamic_template_data'
require 'smartwaiver-sdk/dynamic_template_client'

# The API Key for your account
api_key='<API_KEY>'

# Put Transaction ID here
transaction_id='<TRANSACTION_ID>'

dtc = SmartwaiverDynamicTemplateClient.new(api_key)

begin
  result = dtc.process(transaction_id)
  puts "#{result[:type]}"
  puts "#{result[:dynamic_process][:transactionId]}"
  puts "#{result[:dynamic_process][:waiverId]}"
rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver properties: #{e.message}"
end

