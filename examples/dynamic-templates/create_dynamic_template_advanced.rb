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
require 'base64'

# The API Key for your account
api_key='<API_KEY>'

def sample_legal_text
  txt = <<SAMPLE_LEGAL_TEXT
<p style="text-align:center;"><strong>SAMPLE LEGAL TEXT</strong><br /><strong>All text , form fields, and signature elements can be customized on your waiver.</strong></p>

<p style="text-align:justify;">In consideration of the services of Demo Company, LLC, their agents, owners, officers, volunteers, participants, employees, and all other persons or entities acting in any capacity on their behalf (hereinafter collectively referred to as "DC"), I hereby agree to release and discharge DC, on behalf of myself, my children, my parents, my heirs, assigns, personal representative and estate as follows:</p>

<p style="text-align:justify;">1. I acknowledge that the activities involved in the use of any of DCs services or facilities entail significant risks, both known and unknown, which could result in physical or emotional injury, paralysis, death, or damage to myself, to property, or to third parties.</p>

<p style="text-align:justify;">2. I expressly agree and promise to accept and assume all of the risks existing in these activities, both known and unknown, whether caused or alleged to be caused by the negligent acts or omissions of DC. My participation in this activity is purely voluntary, and I elect to participate in spite of the risks.</p>

<p style="text-align:justify;">3. I hereby voluntarily release, forever discharge, and agree to indemnify and hold harmless DF from any and all claims, demands, or causes of action, which are in any way connected with my participation in this activity or my use of DC equipment or facilities, including any such claims which allege negligent acts or omissions of DC.</p>

<p style="text-align:justify;">4. Should DC or anyone acting on their behalf, be required to incur attorney's fees and costs to enforce this agreement, I agree to indemnify and hold them harmless for all such fees and costs.</p>

<p style="text-align:justify;">5. I certify that I have adequate insurance to cover any injury or damage I may cause or suffer while participating, or else I agree to bear the costs of such injury or damage myself. I further certify that I have no medical or physical conditions which could interfere with my safety in this activity, or else I am willing to assume - and bear the costs of -- all risks that may be created, directly or indirectly, by any such condition.</p>

<p style="text-align:justify;">6. I agree to abide by the rules of the facility. <strong>[initial]</strong></p>

<p style="text-align:justify;">By signing this document, I acknowledge that if anyone is hurt or property is damaged during my participation in this activity, I may be found by a court of law to have waived my right to maintain a lawsuit against DC on the basis of any claim from which I have released them herein.</p>

<p style="text-align:justify;"> </p>

<p style="text-align:justify;"><strong>I HAVE HAD SUFFICIENT OPPORTUNITY TO READ THIS ENTIRE DOCUMENT. I HAVE READ AND UNDERSTAND IT, AND I AGREE TO BE BOUND BY ITS TERMS. </strong></p>

<p style="text-align:justify;"><strong>Today's Date: </strong>[date]</p>
SAMPLE_LEGAL_TEXT
  txt
end

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
th.text = 'Trail Treks Demo Waiver'

# read in image file and convert to base64
current_directory = File.expand_path(__dir__)
logo_file = "#{current_directory}/trail_treks_logo.png"
img_in_base64 = Base64.encode64(File.open(logo_file, "rb").read)

# image must be prefixed correctly to make it an inline image
th.format_image_inline(SmartwaiverTemplateHeader::MEDIA_TYPE_PNG,img_in_base64)
c.header = th

# Text for Template Body
tb = SmartwaiverTemplateBody.new
tb.text = sample_legal_text
c.body = tb

# Participants section configuration
tp = SmartwaiverTemplateParticipants.new
tp.show_middle_name = true
tp.participant_label = "Adventurer's"
c.participants = tp

# Typed Signature only
sig = SmartwaiverTemplateSignatures.new
sig.type = SmartwaiverTemplateSignatures::SIGNATURE_TYPE
sig.default_choice = SmartwaiverTemplateSignatures::SIGNATURE_TYPE
c.signatures = sig

# Redirect configuration (required but not enforced)
comp = SmartwaiverTemplateCompletion.new
comp.redirect_success = 'https://localhost/done?tid=[transactionId]'
comp.redirect_cancel = 'https://localhost/cancel'
c.completion = comp

# Standard Questions - only show one email address
sc = SmartwaiverTemplateStandardQuestions.new
sc.address_enabled = true
sc.default_state_code = 'OR'
sc.email_verification_enabled = false
sc.email_marketing_enabled = true
sc.marketing_opt_in_checked = true
c.standard_questions = sc

# Create the Dyanmic Template Object and assign the data and config
expiration = 10 * 60 # 10 minutes
t = SmartwaiverDynamicTemplate.new(expiration)
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




