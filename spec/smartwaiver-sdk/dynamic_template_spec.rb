dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/dynamic_template"

describe SmartwaiverDynamicTemplate do

  describe "dynamic templates" do
    it "#initialize" do
      dt = SmartwaiverDynamicTemplate.new
      expect(dt).to be_kind_of(SmartwaiverDynamicTemplate)
      expect(dt.data).to be_kind_of(SmartwaiverDynamicTemplateData)
      expect(dt.template_config).to be_kind_of(SmartwaiverDynamicTemplateConfig)
      expect(dt.expiration).to eq(300)
    end

    it "#initialize with non default expiration" do
      dt = SmartwaiverDynamicTemplate.new(30)
      expect(dt.expiration).to eq(30)
    end

    it "to_json default values" do
      dt = SmartwaiverDynamicTemplate.new
      json = dt.to_json
      expect(json).to eq(json_dynamic_template_default)
    end
  end
end

describe SmartwaiverTemplateMeta do
  describe "dynamic template meta" do
    it "#initialize" do
      meta = SmartwaiverTemplateMeta.new
      expect(meta.title).to be_nil
      expect(meta.locale).to be_nil

      a = meta.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      meta = SmartwaiverTemplateMeta.new
      meta.title = "Test"
      meta.locale = "fr_FR"
      a = meta.for_json
      expect(a).to eq({'title' => 'Test', 'locale' => {"locale"=>"fr_FR"}})
    end
  end
end

describe SmartwaiverTemplateHeader do
  describe "dynamic template header" do
    it "#initialize" do
      header = SmartwaiverTemplateHeader.new
      expect(header.text).to be_nil
      expect(header.image_base_64).to be_nil

      a = header.for_json
      expect(a).to eq({})
    end

    it "#format_image_inline" do
      header = SmartwaiverTemplateHeader.new
      header.format_image_inline(SmartwaiverTemplateHeader::MEDIA_TYPE_PNG,"image-text-here")
      expect(header.image_base_64).to eq("data:image/png;base64,image-text-here")
    end

    it "#for_json" do
      header = SmartwaiverTemplateHeader.new
      header.text = "Ruby SDK Test"
      header.image_base_64 = "image-text-here"

      a = header.for_json
      expect(a).to eq({"text"=>"Ruby SDK Test", "logo"=>{"image"=>"image-text-here"}})
    end


  end
end

describe SmartwaiverTemplateBody do
  describe "dynamic template body" do
    it "#initialize" do
      body = SmartwaiverTemplateBody.new
      expect(body.text).to be_nil

      a = body.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      body = SmartwaiverTemplateBody.new
      body.text = "Ruby SDK Test"

      a = body.for_json
      expect(a).to eq({"text"=>"Ruby SDK Test"})
    end
  end
end

describe SmartwaiverTemplateParticipants do
  describe "dynamic template participants" do
    it "#initialize" do
      participants = SmartwaiverTemplateParticipants.new
      expect(participants.adults).to eq(true)
      expect(participants.minors_enabled).to be_nil
      expect(participants.allow_multiple_minors).to be_nil
      expect(participants.allow_without_adults).to be_nil
      expect(participants.allows_adults_and_minors).to be_nil
      expect(participants.age_of_majority).to be_nil
      expect(participants.participant_label).to be_nil
      expect(participants.participating_text).to be_nil
      expect(participants.show_middle_name).to be_nil
      expect(participants.show_phone).to be_nil
      expect(participants.show_gender).to be_nil
      expect(participants.dob_type).to be_nil

      a = participants.for_json
      expect(a).to eq({"adults"=>true})
    end

    it "#for_json" do
      participants = SmartwaiverTemplateParticipants.new

      participants.minors_enabled = true
      participants.allow_multiple_minors = true
      participants.allow_without_adults = false
      participants.allows_adults_and_minors = false
      participants.age_of_majority = 18
      participants.participant_label = "Event Participant"
      participants.participating_text = "Have fun"
      participants.show_middle_name = false
      participants.show_phone = "adults"
      participants.show_gender = true
      participants.dob_type = "select"

      a = participants.for_json
      a_expected = {"adults"=>true,
                    "minors"=>{"enabled"=>true, "multipleMinors"=>true, "minorsWithoutAdults"=>false, "adultsAndMinors" => false},
                    "ageOfMajority" => 18,
                    "participantLabel" => "Event Participant",
                    "participatingText" => "Have fun",
                    "config"=>{"middleName"=>false, "phone"=>"adults", "gender"=>true, "dobType"=>"select"}
                   }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateStandardQuestions do
  describe "dynamic template standard questions" do
    it "#initialize" do
      sq = SmartwaiverTemplateStandardQuestions.new
      expect(sq.address_enabled).to be_nil
      expect(sq.address_required).to be_nil
      expect(sq.default_country_code).to be_nil
      expect(sq.default_state_code).to be_nil
      expect(sq.email_verification_enabled).to be_nil
      expect(sq.email_marketing_enabled).to be_nil
      expect(sq.marketing_opt_in_text).to be_nil
      expect(sq.marketing_opt_in_checked).to be_nil
      expect(sq.emergency_contact_enabled).to be_nil
      expect(sq.insurance_enabled).to be_nil
      expect(sq.id_card_enabled).to be_nil

      a = sq.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      sq = SmartwaiverTemplateStandardQuestions.new

      sq.address_enabled = false
      sq.address_required = false
      sq.default_country_code = 'US'
      sq.default_state_code = 'CA'
      sq.email_verification_enabled = true
      sq.email_marketing_enabled = true
      sq.marketing_opt_in_text = 'Join the mailing list'
      sq.marketing_opt_in_checked = true
      sq.emergency_contact_enabled = true
      sq.insurance_enabled = false
      sq.id_card_enabled = true


      a = sq.for_json
      a_expected = {
          "address"=>{"enabled"=>false, "required"=>false, "defaults"=>{"country"=>"US", "state"=>"CA"}},
          "email"=>{"verification"=>true, "marketing"=>{"enabled"=>true, "optInText"=>"Join the mailing list", "defaultChecked"=>true}},
          "emergencyContact" => {"enabled"=>true},
          "insurance"=>{"enabled"=>true},
          "idCard"=>{"enabled"=>true}
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateGuardian do
  describe "dynamic template guardian" do
    it "#initialize" do
      g = SmartwaiverTemplateGuardian.new
      expect(g.verbiage).to be_nil
      expect(g.verbiage_participant_addendum).to be_nil
      expect(g.label).to be_nil
      expect(g.relationship).to be_nil
      expect(g.age_verification).to be_nil

      a = g.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      g = SmartwaiverTemplateGuardian.new

      g.verbiage = "Guardians are allowed with minors"
      g.verbiage_participant_addendum = "More legal text here"
      g.label = "The Guardian"
      g.relationship = false
      g.age_verification = true

      a = g.for_json
      a_expected = {
          "verbiage"=>"Guardians are allowed with minors",
          "verbiageParticipantAddendum"=>"More legal text here",
          "label"=>"The Guardian",
          "relationship"=>false,
          "ageVerification"=>true
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateElectronicConsent do
  describe "dynamic template electronic Consent" do
    it "#initialize" do
      ec = SmartwaiverTemplateElectronicConsent.new
      expect(ec.title).to be_nil
      expect(ec.verbiage).to be_nil

      a = ec.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      ec = SmartwaiverTemplateElectronicConsent.new

      ec.title = "Electronic Consent Below"
      ec.verbiage = "Use the default text"

      a = ec.for_json
      a_expected = {
          "title"=>"Electronic Consent Below",
          "verbiage"=>"Use the default text"
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateStyling do
  describe "dynamic template styling" do
    it "#initialize" do
      s = SmartwaiverTemplateStyling.new
      @style = nil
      @custom_background_color = nil
      @custom_border_color = nil
      @custom_shadow_color = nil

      expect(s.style).to be_nil
      expect(s.custom_background_color).to be_nil
      expect(s.custom_border_color).to be_nil
      expect(s.custom_shadow_color).to be_nil

      a = s.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      s = SmartwaiverTemplateStyling.new

      s.style = 'custom'
      s.custom_background_color = '#FF0000'
      s.custom_border_color = '#00FF00'
      s.custom_shadow_color = '#0000FF'

      a = s.for_json
      a_expected = {
          "style"=>"custom",
          "custom"=>{"background"=>"#FF0000", "border"=>"#00FF00", "shadow"=>"#0000FF"}
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateCompletion do
  describe "dynamic template completion" do
    it "#initialize" do
      c = SmartwaiverTemplateCompletion.new
      expect(c.redirect_success).to be_nil
      expect(c.redirect_cancel).to be_nil

      a = c.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      c = SmartwaiverTemplateCompletion.new

      c.redirect_success = 'http://127.0.0.1/success'
      c.redirect_cancel = 'http://127.0.0.1/cancel'

      a = c.for_json
      a_expected = {
          "redirect"=>{"success"=>"http://127.0.0.1/success", "cancel"=>"http://127.0.0.1/cancel"}
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateSignatures do
  describe "dynamic template signatures" do
    it "#initialize" do
      s = SmartwaiverTemplateSignatures.new
      expect(s.type).to be_nil
      expect(s.minors).to be_nil
      expect(s.default_choice).to be_nil

      a = s.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      s = SmartwaiverTemplateSignatures.new

      s.type = 'choice'
      s.minors = false
      s.default_choice ='type'

      a = s.for_json
      a_expected = {
          "type"=>"choice",
          "minors"=>false,
          "defaultChoice"=>"type"
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverTemplateProcessing do
  describe "dynamic template processing" do
    it "#initialize" do
      proc = SmartwaiverTemplateProcessing.new
      expect(proc.email_business_name).to be_nil
      expect(proc.email_reply_to).to be_nil
      expect(proc.email_custom_text_enabled).to be_nil
      expect(proc.email_custom_text_web).to be_nil
      expect(proc.email_cc_enabled).to be_nil
      expect(proc.email_cc_web_completed).to be_nil
      expect(proc.email_cc_addresses).to be_nil
      expect(proc.include_bar_codes).to be_nil

      a = proc.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      proc = SmartwaiverTemplateProcessing.new

      proc.email_business_name = 'Smartwaiver'
      proc.email_reply_to = 'no-reply@smartwaiver.com'
      proc.email_custom_text_enabled = true
      proc.email_custom_text_web = "Thanks!"
      proc.email_cc_enabled = true
      proc.email_cc_web_completed = "Online"
      proc.email_cc_addresses = ['no-replay-cc@smartwaiver.com']
      proc.include_bar_codes = true

      a = proc.for_json
      a_expected = {
          "emails"=>{
              "businessName"=>"Smartwaiver",
              "replyTo"=>"no-reply@smartwaiver.com",
              "customText"=>{"enabled"=>true, "web"=>"Thanks!"},
              "cc"=>{"enabled"=>true, "web"=>"Online", "emails"=>["no-replay-cc@smartwaiver.com"]},
              "includeBarcodes"=>true}
      }

      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverDynamicTemplateConfig do

  describe "dynamic template config" do
    it "#initialize" do
      dtc = SmartwaiverDynamicTemplateConfig.new
      expect(dtc).to be_kind_of(SmartwaiverDynamicTemplateConfig)

      expect(dtc.meta).to be_kind_of(SmartwaiverTemplateMeta)
      expect(dtc.header).to be_kind_of(SmartwaiverTemplateHeader)
      expect(dtc.body).to be_kind_of(SmartwaiverTemplateBody)
      expect(dtc.participants).to be_kind_of(SmartwaiverTemplateParticipants)
      expect(dtc.standard_questions).to be_kind_of(SmartwaiverTemplateStandardQuestions)
      expect(dtc.guardian).to be_kind_of(SmartwaiverTemplateGuardian)
      expect(dtc.electronic_consent).to be_kind_of(SmartwaiverTemplateElectronicConsent)
      expect(dtc.styling).to be_kind_of(SmartwaiverTemplateStyling)
      expect(dtc.completion).to be_kind_of(SmartwaiverTemplateCompletion)
      expect(dtc.signatures).to be_kind_of(SmartwaiverTemplateSignatures)
      expect(dtc.processing).to be_kind_of(SmartwaiverTemplateProcessing)
    end

    it "#for_json" do
      dtc = SmartwaiverDynamicTemplateConfig.new

      a = dtc.for_json
      a_expected = {
          "body" => {},
          "completion" => {},
          "electronicConsent" => {},
          "guardian" => {},
          "header" => {},
          "meta" => {},
          "participants" => {"adults"=>true},
          "processing" => {},
          "signatures" => {},
          "standardQuestions" => {},
          "styling" => {}
      }

      expect(a).to eq(a_expected)
    end
  end

end
