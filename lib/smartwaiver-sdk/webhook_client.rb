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

require 'smartwaiver-sdk/smartwaiver_base'

class SmartwaiverWebhookClient < SmartwaiverSDK::SmartwaiverBase

  WEBHOOK_AFTER_EMAIL_ONLY = 'yes'
  WEBHOOK_BEFORE_EMAIL_ONLY = 'no'
  WEBHOOK_BEFORE_AND_AFTER_EMAIL = 'both'

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def configuration
    path =  @rest_endpoints[:configure]
    make_api_request(path, HTTP_GET)
  end

  def configure(endpoint, email_validation_required)
    path =  @rest_endpoints[:configure]
    json = {:endpoint => endpoint, :emailValidationRequired => email_validation_required}.to_json
    make_api_request(path, HTTP_PUT, json)
  end

  private

  def define_rest_endpoints
    {
        :configure => "/v4/webhooks/configure"
    }
  end
end
