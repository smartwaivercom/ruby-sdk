dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/waiver_client"

describe SmartwaiverWaiverClient do
  attr_reader :client, :api_key

  before do
    @api_key = "apikey"
    @client = SmartwaiverWaiverClient.new(@api_key)
  end

  describe "waivers" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverWaiverClient)
    end

    it "#list all default values" do
      path = "#{API_URL}/v4/waivers?limit=20"
      stub_request(:get, path).to_return(body: json_waiver_list_results)
      result = @client.list
      expect(result[:waivers].length).to eq(3)
    end

    it "#list with all values specified" do
      limit = 3
      verified = true
      template_id = "586ffe15134bd"
      from_dts = '2017-01-01T00:00:00Z'
      to_dts = '2017-02-01T00:00:00Z'

      path = "#{API_URL}/v4/waivers?limit=#{limit}&verified=#{verified}&templateId=#{template_id}&fromDts=#{from_dts}&toDts=#{to_dts}"
      stub_request(:get, path).to_return(body: json_waiver_list_results)
      @client.list(limit, verified, template_id, from_dts, to_dts)
    end

    it "#get without pdf" do
      waiver_id = "Vzy8f6gnCWVcQBURdydwPT"
      path = "#{API_URL}/v4/waivers/#{waiver_id}?pdf=false"
      stub_request(:get, path).to_return(body: json_waiver_single_results)
      result = @client.get(waiver_id)

      expect(result[:waiver][:waiverId]).to eq(waiver_id)
      expect(result[:waiver][:participants].length).to eq(2)
      expect(result[:waiver][:customWaiverFields][:"58458759da897"][:value]).to eq ("Testing")
    end

    it "#get with pdf" do
      waiver_id = "Vzy8f6gnCWVcQBURdydwPT"
      path = "#{API_URL}/v4/waivers/#{waiver_id}?pdf=true"
      stub_request(:get, path).to_return(body: json_waiver_single_results)
      @client.get(waiver_id, true)
    end

    it "#photos" do
      waiver_id = "6jebdfxzvrdkd"
      path = "#{API_URL}/v4/waivers/#{waiver_id}/photos"
      stub_request(:get, path).to_return(body: json_waiver_photos_results)
      result = @client.photos(waiver_id)

      expect(result[:photos][:waiverId]).to eq(waiver_id)
      expect(result[:photos][:templateId]).to eq("sprswrvh2keeh")
      expect(result[:photos][:title]).to eq("Smartwaiver Demo Waiver")

      expect(result[:photos][:photos].length).to eq(1)
      expect(result[:photos][:photos][0][:type]).to eq("kiosk")
      expect(result[:photos][:photos][0][:tag]).to eq("IP: 192.168.2.0")
      expect(result[:photos][:photos][0][:fileType]).to eq("jpg")
      expect(result[:photos][:photos][0][:photoId]).to eq("CwLeDjffgDoGHua")
      expect(result[:photos][:photos][0][:photo]).to eq("BASE64 ENCODED PHOTO")
    end

    it "#signatures" do
      waiver_id = "6jebdfxzvrdkd"
      path = "#{API_URL}/v4/waivers/#{waiver_id}/signatures"
      stub_request(:get, path).to_return(body: json_waiver_signatures_results)
      result = @client.signatures(waiver_id)

      expect(result[:signatures][:waiverId]).to eq(waiver_id)
      expect(result[:signatures][:templateId]).to eq("sprswrvh2keeh")
      expect(result[:signatures][:title]).to eq("Smartwaiver Demo Waiver")

      expect(result[:signatures][:signatures][:participants].length).to eq(1)
      expect(result[:signatures][:signatures][:guardian].length).to eq(1)
      expect(result[:signatures][:signatures][:bodySignatures].length).to eq(1)
      expect(result[:signatures][:signatures][:bodyInitials].length).to eq(1)
    end

  end
end
