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

require 'smartwaiver-sdk/webhook_client'

# The API Key for your account
api_key='[INSERT API KEY]'

client = SmartwaiverWebhookClient.new(api_key)

end_point = 'http://example.org'
send_after_email_only = SmartwaiverWebhookClient::WEBHOOK_AFTER_EMAIL_ONLY

begin
  result = client.configure(end_point, send_after_email_only)

  webhook = result[:webhooks]
  puts "Successfully set new configuration."
  puts "Endpoint: #{webhook[:endpoint]}"
  puts "EmailValidationRequired: #{webhook[:emailValidationRequired]}"
rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue SmartwaiverSDK::BadFormatError=>bfe
  puts "Request or Data not correct: #{bfe.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during webhook configuration: #{e.message}"
end
