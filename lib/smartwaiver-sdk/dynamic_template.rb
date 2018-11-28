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
require 'smartwaiver-sdk/dynamic_template_data'

class SmartwaiverDynamicTemplate

  EXPIRATION_DEFAULT = 300

  attr_accessor :expiration, :template_config, :data

  def initialize(expiration = EXPIRATION_DEFAULT)
    @expiration = expiration
    @template_config = SmartwaiverDynamicTemplateConfig.new
    @data = SmartwaiverDynamicTemplateData.new
  end

  def to_json
    {:template => @template_config.for_json, :data => @data.for_json}.to_json
  end
end


class SmartwaiverDynamicTemplateConfig

  attr_accessor :meta, :header, :body, :participants,
                :standard_questions, :guardian, :electronic_consent,
                :styling, :completion, :signatures, :processing

  def initialize()
    @meta = SmartwaiverTemplateMeta.new
    @header = SmartwaiverTemplateHeader.new
    @body = SmartwaiverTemplateBody.new
    @participants = SmartwaiverTemplateParticipants.new
    @standard_questions = SmartwaiverTemplateStandardQuestions.new
    @guardian = SmartwaiverTemplateGuardian.new
    @electronic_consent = SmartwaiverTemplateElectronicConsent.new
    @styling = SmartwaiverTemplateStyling.new
    @completion = SmartwaiverTemplateCompletion.new
    @signatures = SmartwaiverTemplateSignatures.new
    @processing = SmartwaiverTemplateProcessing.new
  end

  def for_json
    {
      'meta' => @meta.for_json,
      'header' => @header.for_json,
      'body' => @body.for_json,
      'participants' => @participants.for_json,
      'standardQuestions' => @standard_questions.for_json,
      'guardian' => @guardian.for_json,
      'electronicConsent' => @electronic_consent.for_json,
      'styling' => @styling.for_json,
      'completion' => @completion.for_json,
      'signatures' => @signatures.for_json,
      'processing' => @processing.for_json
     }
  end
end

class SmartwaiverTemplateMeta

  attr_accessor :title, :locale

  def initialize()
    @title = nil
    @locale = nil
  end

  def for_json
    json = {}
    json['title'] = @title if (!@title.nil?)
    json['locale'] = {'locale' => @locale} if (!@locale.nil?)
    json
  end
end

class SmartwaiverTemplateHeader

  MEDIA_TYPE_PNG = 'image/png'
  MEDIA_TYPE_JPEG = 'image/jpeg'

  attr_accessor :text, :image_base_64

  def initialize()
    @text = nil
    @image_base_64 = nil
  end

  def format_image_inline(media_type, encoded_image)
    @image_base_64 = "data:#{media_type};base64,#{encoded_image}"
  end

  def for_json
    json = {}
    json['text'] = @text if (!@text.nil?)
    json['logo'] = {'image' => @image_base_64} if (!@image_base_64.nil?)
    json
  end
end

class SmartwaiverTemplateBody

  attr_accessor :text

  def initialize()
    @text = nil
  end

  def for_json
    json = {}
    json['text'] = @text if (!@text.nil?)
    json
  end
end

class SmartwaiverTemplateParticipants

  ADULTS_AND_MINORS = 'adultsAndMinors'
  MINORS_WITHOUT_ADULTS = 'minorsWithoutAdults'

  PHONE_ADULTS_ONLY = 'adults'
  PHOHE_ADULTS_AND_MINORS = 'adultsAndMinors'

  DOB_CHECKBOX = 'checkbox'
  DOB_SELECT = 'select'

  attr_accessor :adults, :minors_enabled, :allow_multiple_minors, :allow_without_adults,
                :allows_adults_and_minors, :age_of_majority, :participant_label, :participating_text,
                :show_middle_name, :show_phone, :show_gender, :dob_type

  def initialize()
    @adults = true
    @minors_enabled = nil
    @allow_multiple_minors = nil
    @allow_without_adults = nil
    @allows_adults_and_minors = nil
    @age_of_majority = nil
    @participant_label = nil
    @participating_text = nil
    @show_middle_name = nil
    @show_phone = nil
    @show_gender = nil
    @dob_type = nil
  end

  def for_json
    json = {}
    json['adults'] = @adults if (!@adults.nil?)

    minors = {}
    minors['enabled'] = @minors_enabled if (!@minors_enabled.nil?)
    minors['multipleMinors'] = @allow_multiple_minors if (!@allow_multiple_minors.nil?)
    minors['minorsWithoutAdults'] = @allow_without_adults if (!@allow_without_adults.nil?)
    minors['adultsAndMinors'] = @allows_adults_and_minors if (!@allows_adults_and_minors.nil?)
    json['minors'] = minors if (minors != {})

    json['ageOfMajority'] = @age_of_majority if (!@age_of_majority.nil?)
    json['participantLabel'] = @participant_label if (!@participant_label.nil?)
    json['participatingText'] = @participating_text if (!@participating_text.nil?)

    config = {}
    config['middleName'] = @show_middle_name if (!@show_middle_name.nil?)
    config['phone'] = @show_phone if (!@show_phone.nil?)
    config['gender'] = @show_gender if (!@show_gender.nil?)
    config['dobType'] = @dob_type if (!@dob_type.nil?)
    json['config'] = config if (config != {})

    json
  end
end


class SmartwaiverTemplateStandardQuestions

  attr_accessor :address_enabled, :address_required, :default_country_code, :default_state_code,
                :email_verification_enabled, :email_marketing_enabled, :marketing_opt_in_text,
                :marketing_opt_in_checked, :emergency_contact_enabled, :insurance_enabled, :id_card_enabled
  def initialize()
    @address_enabled = nil
    @address_required = nil
    @default_country_code = nil
    @default_state_code = nil
    @email_verification_enabled = nil
    @email_marketing_enabled = nil
    @marketing_opt_in_text = nil
    @marketing_opt_in_checked = nil
    @emergency_contact_enabled = nil
    @insurance_enabled = nil
    @id_card_enabled = nil
  end

  def for_json
    json = {}
    address = {}
    address['enabled'] = @address_enabled if (!@address_enabled.nil?)
    address['required'] = @address_required if (!@address_required.nil?)
    defaults = {}
    defaults['country'] = @default_country_code if (!@default_country_code.nil?)
    defaults['state'] = @default_state_code if (!@default_state_code.nil?)
    address['defaults'] = defaults if (defaults != {})
    json['address'] = address if (address != {})

    email = {}
    email['verification'] = @email_verification_enabled if (!@email_verification_enabled.nil?)
    email_marketing = {}
    email_marketing['enabled'] = @email_marketing_enabled if (!@email_marketing_enabled.nil?)
    email_marketing['optInText'] = @marketing_opt_in_text if (!@marketing_opt_in_text.nil?)
    email_marketing['defaultChecked'] = @marketing_opt_in_checked if (!@marketing_opt_in_checked.nil?)
    email['marketing'] = email_marketing if (email_marketing != {})
    json['email'] = email if (email != {})

    emergency_contact = {}
    emergency_contact['enabled'] = @emergency_contact_enabled if (!@emergency_contact_enabled.nil?)
    json['emergencyContact'] = emergency_contact if (emergency_contact != {})

    insurance = {}
    insurance['enabled'] = @insurance_enabled if (!@insurance_enabled.nil?)
    json['insurance'] = emergency_contact if (emergency_contact != {})

    id_card = {}
    id_card['enabled'] = @id_card_enabled if (!@id_card_enabled.nil?)
    json['idCard'] = id_card if (id_card != {})
    json
  end
end

class SmartwaiverTemplateGuardian

  attr_accessor :verbiage, :verbiage_participant_addendum, :label, :relationship, :age_verification

  def initialize()
    @verbiage = nil
    @verbiage_participant_addendum = nil
    @label = nil
    @relationship = nil
    @age_verification = nil
  end

  def for_json
    json = {}
    json['verbiage'] = @verbiage if (!@verbiage.nil?)
    json['verbiageParticipantAddendum'] = @verbiage_participant_addendum if (!@verbiage_participant_addendum.nil?)
    json['label'] = @label if (!@label.nil?)
    json['relationship'] = @relationship if (!@relationship.nil?)
    json['ageVerification'] = @age_verification if (!@age_verification.nil?)
    json
  end
end

class SmartwaiverTemplateElectronicConsent

  attr_accessor :title, :verbiage

  def initialize()
    @title = nil
    @verbiage = nil
  end

  def for_json
    json = {}
    json['title'] = @title if (!@title.nil?)
    json['verbiage'] = @verbiage if (!@verbiage.nil?)
    json
  end
end

class SmartwaiverTemplateStyling

  attr_accessor :style, :custom_background_color, :custom_border_color, :custom_shadow_color

  def initialize()
    @style = nil
    @custom_background_color = nil
    @custom_border_color = nil
    @custom_shadow_color = nil
  end

  def for_json
    json = {}
    json['style'] = @style if (!@style.nil?)

    custom = {}
    custom['background'] = @custom_background_color if (!@custom_background_color.nil?)
    custom['border'] = @custom_border_color if (!@custom_border_color.nil?)
    custom['shadow'] = @custom_shadow_color if (!@custom_shadow_color.nil?)
    json['custom'] = custom if (custom != {})

    json
  end
end

class SmartwaiverTemplateCompletion

  attr_accessor :redirect_success, :redirect_cancel

  def initialize()
    @redirect_success = nil
    @redirect_cancel = nil
  end

  def for_json
    json = {}
    redirect = {}
    redirect['success'] = @redirect_success if (!@redirect_success.nil?)
    redirect['cancel'] = @redirect_cancel  if (!@redirect_cancel .nil?)
    json['redirect'] = redirect if (redirect != {})
    json
  end
end

class SmartwaiverTemplateSignatures

  SIGNATURE_DRAW = 'draw'
  SIGNATURE_TYPE = 'type'
  SIGNATURE_CHOICE = 'choice'

  attr_accessor :type, :minors, :default_choice

  def initialize()
    @type = nil
    @minors = nil
    @default_choice = nil
  end

  def for_json
    json = {}
    json['type'] = @type if (!@type.nil?)
    json['minors'] = @minors if (!@minors.nil?)
    json['defaultChoice'] = @default_choice if (!@default_choice.nil?)
    json
  end
end

class SmartwaiverTemplateProcessing

  attr_accessor :email_business_name, :email_reply_to, :email_custom_text_enabled,
                :email_custom_text_web, :email_cc_enabled, :email_cc_web_completed,
                :email_cc_addresses, :include_bar_codes

  def initialize()
    @email_business_name  = nil
    @email_reply_to = nil
    @email_custom_text_enabled = nil
    @email_custom_text_web = nil
    @email_cc_enabled = nil
    @email_cc_web_completed = nil
    @email_cc_addresses = nil
    @include_bar_codes = nil
  end

  def for_json
    json = {}
    emails = {}

    emails['businessName'] = @email_business_name if (!@email_business_name.nil?)
    emails['replyTo'] = @email_reply_to if (!@email_reply_to.nil?)

    customText = {}
    customText['enabled'] = @email_custom_text_enabled if (!@email_custom_text_enabled.nil?)
    customText['web'] = @email_custom_text_web if (!@email_custom_text_web.nil?)
    emails['customText'] = customText if (customText != {})

    cc = {}
    cc['enabled'] = @email_cc_enabled if (!@email_cc_enabled.nil?)
    cc['web'] = @email_cc_web_completed if (!@email_cc_web_completed.nil?)
    cc['emails'] = @email_cc_addresses if (!@email_cc_addresses.nil?)
    emails['cc'] = cc if (cc != {})

    emails['includeBarcodes'] = @include_bar_codes if (!@include_bar_codes.nil?)
    json['emails'] = emails if (emails != {})
    json
  end
end
