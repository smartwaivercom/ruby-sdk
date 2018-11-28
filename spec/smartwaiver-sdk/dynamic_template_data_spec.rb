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

    it "#for_json" do
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