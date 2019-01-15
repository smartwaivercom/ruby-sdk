dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/dynamic_template_data"

describe SmartwaiverDynamicTemplateData do

  before do
    FakeWeb.allow_net_connect = false
  end

  describe "dynamic template data" do
    it "#initialize" do
      td = SmartwaiverDynamicTemplateData.new
      expect(td).to be_kind_of(SmartwaiverDynamicTemplateData)
      expect(td.adult).to eq(true)
      expect(td.participants).to eq([])
      expect(td.guardian).to be_kind_of(SmartwaiverGuardian)
      expect(td.address_line_one).to be_nil
      expect(td.address_line_two).to be_nil
      expect(td.address_country).to be_nil
      expect(td.address_state).to be_nil
      expect(td.address_zip).to be_nil
      expect(td.email).to be_nil
      expect(td.emergency_contact_name).to be_nil
      expect(td.emergency_contact_phone).to be_nil
      expect(td.insurance_carrier).to be_nil
      expect(td.insurance_policy_number).to be_nil
      expect(td.drivers_license_state).to be_nil
      expect(td.drivers_license_number).to be_nil
    end

    it "#initialize with non default adult" do
      td = SmartwaiverDynamicTemplateData.new(false)
      expect(td.adult).to eq(false)
    end

    it "#add_participant" do
      td = SmartwaiverDynamicTemplateData.new

      p = SmartwaiverParticipant.new
      p.first_name = "Rocky"
      p.last_name = "RockChuck"

      td.add_participant(p)

      expect(td.participants).to eq([p])
    end

    it "#for_json minimal" do
      td = SmartwaiverDynamicTemplateData.new

      p = SmartwaiverParticipant.new
      p.first_name = "Rocky"
      p.last_name = "RockChuck"

      td.add_participant(p)

      a = td.for_json

      a_expected = {
          "adult"=>true,
          "participants"=>[{"firstName"=>"Rocky", "lastName"=>"RockChuck"}],
          "guardian"=>{"participant"=>false}
      }
      expect(a).to eq(a_expected)
    end

    it "#for_json all fields" do
      td = SmartwaiverDynamicTemplateData.new(false)

      p = SmartwaiverParticipant.new
      p.first_name = "Rocky"
      p.last_name = "RockChuck"
      p.gender = "M"
      p.dob = "2010-01-01"

      td.add_participant(p)

      td.address_line_one = "123 Main St."
      td.address_line_two = "Apt A"
      td.address_country = "US"
      td.address_state = "OR"
      td.address_zip = "97703"
      td.email = "rocky@smartwaiver.com"
      td.emergency_contact_name = "Mrs Rocky"
      td.emergency_contact_phone = "800-555-1212"
      td.insurance_carrier = "Aetna"
      td.insurance_policy_number = "H01"
      td.drivers_license_state = "OR"
      td.drivers_license_number = "010101"

      a = td.for_json

      a_expected = {
          "adult"=>false,
          "participants"=>[{"firstName"=>"Rocky", "lastName"=>"RockChuck", "gender" => "M", "dob" => "2010-01-01"}],
          "guardian"=>{"participant"=>false},
          "addressLineOne" => "123 Main St.",
          "addressLineTwo" => "Apt A",
          "addressCountry" => "US",
          "addressState" => "OR",
          "addressZip" => "97703",
          "email" => "rocky@smartwaiver.com",
          "emergencyContactName" => "Mrs Rocky",
          "emergencyContactPhone" => "800-555-1212",
          "insuranceCarrier" => "Aetna",
          "insurancePolicyNumber" => "H01",
          "driversLicenseState" => "OR",
          "driversLicenseNumber" => "010101"
      }
      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverParticipant do
  describe "Participant Data" do
    it "#initialize" do
      p = SmartwaiverParticipant.new
      expect(p.first_name).to be_nil
      expect(p.middle_name).to be_nil
      expect(p.last_name).to be_nil
      expect(p.phone).to be_nil
      expect(p.gender).to be_nil
      expect(p.dob).to be_nil

      a = p.for_json
      expect(a).to eq({})
    end

    it "#for_json" do
      p = SmartwaiverParticipant.new

      p.first_name = "Rocky"
      p.middle_name = "R"
      p.last_name = "RockChuck"
      p.phone = "800-555-1212"
      p.gender = "M"
      p.dob = '1970-01-01'

      a = p.for_json
      a_expected = {
          "firstName"=>"Rocky",
          "middleName"=>"R",
          "lastName"=>"RockChuck",
          "phone"=>"800-555-1212",
          "gender"=>"M",
          "dob"=>"1970-01-01"
      }
      expect(a).to eq(a_expected)
    end
  end
end

describe SmartwaiverGuardian do
  describe "Guardian Data" do
    it "#initialize" do
      g = SmartwaiverGuardian.new

      expect(g.participant).to eq(false)
      expect(g.first_name).to be_nil
      expect(g.middle_name).to be_nil
      expect(g.last_name).to be_nil
      expect(g.relationship).to be_nil
      expect(g.phone).to be_nil
      expect(g.gender).to be_nil
      expect(g.dob).to be_nil

      a = g.for_json
      expect(a).to eq({"participant" => false})
    end

    it "#for_json" do
      g = SmartwaiverGuardian.new

      g.participant = false
      g.first_name = "Rocky"
      g.middle_name = "R"
      g.last_name = "RockChuck"
      g.phone = "800-555-1212"
      g.gender = "M"
      g.dob = '1970-01-01'

      a = g.for_json
      a_expected = {
          "participant"=>false,
          "firstName"=>"Rocky",
          "middleName"=>"R",
          "lastName"=>"RockChuck",
          "phone"=>"800-555-1212",
          "gender"=>"M",
          "dob"=>"1970-01-01"
      }
      expect(a).to eq(a_expected)
    end
  end
end