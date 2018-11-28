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

class SmartwaiverSearchClient < SmartwaiverSDK::SmartwaiverBase

  EMPTY_SEARCH_PARAMETER = ''
  SEARCH_SORT_ASC = 'asc'
  SEARCH_SORT_DESC = 'desc'

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def search(template_id = EMPTY_SEARCH_PARAMETER,
             from_dts = EMPTY_SEARCH_PARAMETER,
             to_dts = EMPTY_SEARCH_PARAMETER,
             first_name = EMPTY_SEARCH_PARAMETER,
             last_name = EMPTY_SEARCH_PARAMETER,
             verified = EMPTY_SEARCH_PARAMETER,
             sort = EMPTY_SEARCH_PARAMETER,
             tag = EMPTY_SEARCH_PARAMETER)

    qs = {}
    qs[:templateId] = template_id if (template_id != EMPTY_SEARCH_PARAMETER)
    qs[:fromDts] = from_dts if (from_dts != EMPTY_SEARCH_PARAMETER)
    qs[:toDts] = to_dts if (to_dts != EMPTY_SEARCH_PARAMETER)
    qs[:firstName] = first_name if (first_name != EMPTY_SEARCH_PARAMETER)
    qs[:lastName] = last_name if (last_name != EMPTY_SEARCH_PARAMETER)
    qs[:verified] = verified if (verified != EMPTY_SEARCH_PARAMETER)
    qs[:sort] = sort if (sort != EMPTY_SEARCH_PARAMETER)
    qs[:tag] = tag if (tag != EMPTY_SEARCH_PARAMETER)

    path =  @rest_endpoints[:search] + (qs != {} ? ('?' + create_query_string(qs)) : '')
    make_api_request(path, HTTP_GET)
  end

  def results(search_guid, page = 0)
    path = "#{@rest_endpoints[:search]}/#{search_guid}/results?page=#{page}"
    make_api_request(path, HTTP_GET)
  end

  private

  def define_rest_endpoints
    {
        :search => "/v4/search"
    }
  end
end
