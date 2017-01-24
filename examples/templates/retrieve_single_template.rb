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

require 'smartwaiver-sdk/template_client'

# The API Key for your account
api_key='[INSERT API KEY]'

# The Template ID
template_id='[INSERT TEMPLATE ID]'

client = SmartwaiverTemplateClient.new(api_key)

begin
  result = client.get(template_id)
  template = result[:template]

  puts "List single template:"
  puts "#{template[:templateId]}: #{template[:title]}"
rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during template retrieval: #{e.message}"
end
