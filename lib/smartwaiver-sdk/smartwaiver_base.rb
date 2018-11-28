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

require 'json'
require 'net/http'
require 'smartwaiver-sdk/smartwaiver_version'
require 'smartwaiver-sdk/smartwaiver_errors'

module SmartwaiverSDK

  class SmartwaiverBase
    DEFAULT_API_ENDPOINT = 'https://api.smartwaiver.com'
    HEADER_API_KEY = 'sw-api-key'
    HTTP_READ_TIMEOUT = 60

    HTTP_GET = "GET"
    HTTP_POST = "POST"
    HTTP_PUT = "PUT"
    HTTP_DELETE = "DELETE"


    def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
      @api_endpoint = api_endpoint
      @api_key = api_key
      @http = nil
      @http_read_timeout = HTTP_READ_TIMEOUT
      init_http_connection(@api_endpoint)
    end

    def api_version
      make_api_request("/version")
    end

    def format_iso_time(time)
      time.strftime("%Y-%m-%dT%H:%M:%SZ")
    end

    def read_timeout(s)
      if s > 0 and s < 600
        @http_read_timeout = s
      end
    end

    private

    def init_http_connection(target_server)
      if (@http and @http.started?)
        @http.finish
      end
      @last_init_time = Time.now.utc
      endpoint_url = URI.parse(target_server)
      @http = Net::HTTP.start(endpoint_url.host, endpoint_url.port, {:use_ssl => true, :read_timeout => @http_read_timeout})
      @http
    end

    def common_http_headers
      {'User-Agent' => SmartwaiverSDK::Info.get_user_agent, HEADER_API_KEY => @api_key}
    end

    def rest_post_headers
      {"Content-Type" => "application/json"}
    end

    def make_api_request(path, request_type=HTTP_GET, data='')
      if (@last_init_time < Time.now.utc - 60)
        init_http_connection(@api_endpoint)
      end

      headers = common_http_headers
      case request_type
        when HTTP_GET
          response = @http.request_get(path, headers)
        when HTTP_PUT
          headers = common_http_headers.merge(rest_post_headers)
          response = @http.request_put(path, data, headers)
        when HTTP_POST
          headers = common_http_headers.merge(rest_post_headers)
          response = @http.request_post(path, data, headers)
      when HTTP_DELETE
        headers = common_http_headers.merge(rest_post_headers)
        response = @http.delete(path, headers)
      end
      check_response(response)
    end

    def check_response(response)
      response_data = parse_response_body(response.body)
      case response
        when Net::HTTPSuccess
          return response_data
        when Net::HTTPUnauthorized
          raise SmartwaiverSDK::BadAPIKeyError.new("#{response.code.to_s}:#{response_data[:message]}", response_data)
        when Net::HTTPNotAcceptable
          raise SmartwaiverSDK::BadFormatError.new("#{response.code.to_s}:#{response_data[:message]}", response_data)
        when Net::HTTPClientError, Net::HTTPServerError
          raise SmartwaiverSDK::RemoteServerError.new("#{response.code.to_s}:#{response_data[:message]}", response_data)
        else
          raise SmartwaiverSDK::RemoteServerError.new("#{response_data[:message]}", response_data)
      end
    end

    def parse_response_body(body)
      begin
        return JSON.parse(body, :symbolize_names => :symbolize_names)
      rescue JSON::ParserError => e
        return base_response_params.merge!({:message => e.message})
      end
    end

    def base_response_params
      {:version => 0,
       :id => "",
       :ts => "1970-01-01T00:00:00+00:00",
       :type => ""
      }
    end

    def create_query_string(params)
      URI.encode_www_form(params)
    end
  end
end
