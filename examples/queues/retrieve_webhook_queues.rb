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
  result = client.information
  queue_information = result[:api_webhook_all_queue_message_count]

  if (queue_information.nil?)
    puts "Account Queue: N/A"
  else

    puts "Account Queue"
    puts "  Total Messages      : #{queue_information[:account][:messagesTotal]}"
    puts "  Messages Not Visible: #{queue_information[:account][:messagesNotVisible]}"
    puts "  Messages Delayed    : #{queue_information[:account][:messagesDelayed]}"

    queue_information.keys.each do |k|
      if k.match(/^template/)
        template_queue_info = queue_information[k]
        puts "Template Queue (#{k}):"
        puts "  Total Messages      : #{template_queue_info[:messagesTotal]}"
        puts "  Messages Not Visible: #{template_queue_info[:messagesNotVisible]}"
        puts "  Messages Delayed    : #{template_queue_info[:messagesDelayed]}"
      end
    end
  end

rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during queue information: #{e.message}"
end

