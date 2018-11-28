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

class SmartwaiverWaiverClient < SmartwaiverSDK::SmartwaiverBase

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def list(limit = 20, verified = nil, template_id = '', from_dts = '', to_dts = '')
    path = "#{@rest_endpoints[:waivers]}?limit=#{limit}"
    if !verified.nil?
      path = "#{path}&verified=" + (verified ? 'true' : 'false')
    end
    if !template_id.empty?
      path = "#{path}&templateId=#{template_id}"
    end
    if !from_dts.empty?
      path = "#{path}&fromDts=#{from_dts}"
    end
    if !to_dts.empty?
      path = "#{path}&toDts=#{to_dts}"
    end
    make_api_request(path, HTTP_GET)
  end

  def get(waiver_id, pdf=false)
    path =  "#{@rest_endpoints[:waivers]}/#{waiver_id}?pdf=" + (pdf ? 'true' : 'false')
    make_api_request(path, HTTP_GET)
  end

  def photos(waiver_id)
    path =  "#{@rest_endpoints[:waivers]}/#{waiver_id}/photos"
    make_api_request(path, HTTP_GET)
  end

  def signatures(waiver_id)
    path =  "#{@rest_endpoints[:waivers]}/#{waiver_id}/signatures"
    make_api_request(path, HTTP_GET)
  end

  private

  def define_rest_endpoints
    {
        :waivers => "/v4/waivers"
    }
  end
end

