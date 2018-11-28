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

require 'smartwaiver-sdk/webhook_queues_client'

# The API Key for your account
api_key='<API_KEY>'

client = SmartwaiverWebhookQueuesClient.new(api_key)

begin
  result = client.get_message
  message = result[:api_webhook_account_message_get]

  if (message.nil?)
    puts "No messages in account queue"
    Kernel.exit(1)
  end


  puts "Message in Account Queue"
  puts "  Message ID: #{message[:messageId]}"
  puts "  Message Payload"
  puts "    Waiver ID: #{message[:payload][:unique_id]}"
  puts "    Event    : #{message[:payload][:event]}"

  #
  # Now that we have retrieved the message we can delete it
  delete_result = client.delete_message(message[:messageId])

  puts "Delete Success:" + (delete_result[:api_webhook_account_message_delete][:success] ? "true" : "false")

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue SystemExit => se
  puts ""
rescue Exception=>e
  puts "Exception thrown.  Error during queue information: #{e.message}"
end
