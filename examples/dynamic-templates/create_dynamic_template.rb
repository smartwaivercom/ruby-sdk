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


# Create Dynamic Template Sample Code
#
# export RUBYLIB=<path>/sw-sdk-ruby/lib
#

require 'smartwaiver-sdk/dynamic_template'
require 'smartwaiver-sdk/dynamic_template_data'
require 'smartwaiver-sdk/dynamic_template_client'

# The API Key for your account
api_key='<API_KEY>'

# Create data object for pre-fill
data = SmartwaiverDynamicTemplateData.new

# Create a participant and then add to data object
participant = SmartwaiverParticipant.new
participant.first_name='Rocky'
participant.last_name='Chuck'
participant.dob = '1986-01-02'
data.add_participant(participant)


# Create Template Configuration object
c = SmartwaiverDynamicTemplateConfig.new

# Text for Template Header
th = SmartwaiverTemplateHeader.new
th.text = 'Sample Dynamic Waiver from Ruby SDK'
c.header = th

# Text for Template Body
tb = SmartwaiverTemplateBody.new
tb.text = 'This template is <b>only</b> for testing!'
c.body = tb

# Participants section configuration
tp = SmartwaiverTemplateParticipants.new
tp.show_middle_name = false
c.participants = tp

# Redirect configuration (required but not enforced)
comp = SmartwaiverTemplateCompletion.new
comp.redirect_success = 'https://localhost/done?tid=[transactionId]'
comp.redirect_cancel = 'https://localhost/cancel'
c.completion = comp

# Standard Questions - only show one email address
sc = SmartwaiverTemplateStandardQuestions.new
sc.email_verification_enabled = false
c.standard_questions = sc

# Create the Dyanmic Template Object and assign the data and config
t = SmartwaiverDynamicTemplate.new
t.data = data
t.template_config = c

# Create the Dynamic Template Client and then create the dynamic template.  Return information includes URL for template
dtc = SmartwaiverDynamicTemplateClient.new(api_key)
begin
  result = dtc.create(t)

  puts "Dynamic Template Information"
  puts "  Type: #{result[:type]}"
  puts "  URL : #{result[:dynamic][:url]}"
  puts "  UUID: #{result[:dynamic][:uuid]}"
  puts "  Exp : #{result[:dynamic][:expiration]}"
rescue SmartwaiverSDK::BadAPIKeyError=>bad
  puts "API Key error: #{bad.message}"
rescue Exception=>e
  puts "Exception thrown.  Error during waiver properties: #{e.message}"
end





