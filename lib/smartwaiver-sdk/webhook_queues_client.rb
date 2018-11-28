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

require 'smartwaiver-sdk/smartwaiver_base'

class SmartwaiverWebhookQueuesClient < SmartwaiverSDK::SmartwaiverBase

  WEBHOOK_AFTER_EMAIL_ONLY = 'yes'
  WEBHOOK_BEFORE_EMAIL_ONLY = 'no'
  WEBHOOK_BEFORE_AND_AFTER_EMAIL = 'both'

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def information
    path =  @rest_endpoints[:queues]
    make_api_request(path, HTTP_GET)
  end

  def get_message
    path =  @rest_endpoints[:account]
    make_api_request(path, HTTP_GET)
  end

  def delete_message(message_id)
    path =  "#{@rest_endpoints[:account]}/#{message_id}"
    make_api_request(path, HTTP_DELETE)
  end

  def get_template_message(template_id)
    path =  "#{@rest_endpoints[:template]}/#{template_id}"
    make_api_request(path, HTTP_GET)
  end

  def delete_template_message(template_id, message_id)
    path =  "#{@rest_endpoints[:template]}/#{template_id}/#{message_id}"
    make_api_request(path, HTTP_DELETE)
  end

  private

  def define_rest_endpoints
    {
        :queues => "/v4/webhooks/queues",
        :account => "/v4/webhooks/queues/account",
        :template => "/v4/webhooks/queues/template"
    }
  end
end
