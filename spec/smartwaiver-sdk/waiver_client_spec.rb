dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/waiver_client"

describe SmartwaiverWaiverClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "apikey"
    @client = SmartwaiverWaiverClient.new(@api_key)
  end

  describe "waivers" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverWaiverClient)
    end

    it "#list all default values" do
      path = "#{API_URL}/v4/waivers?limit=20"
      FakeWeb.register_uri(:get, path, :body => json_waiver_list_results)
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
      FakeWeb.register_uri(:get, path, :body => json_waiver_list_results)
      @client.list(limit, verified, template_id, from_dts, to_dts)
    end

    it "#get without pdf" do
      waiver_id = "Vzy8f6gnCWVcQBURdydwPT"
      path = "#{API_URL}/v4/waivers/#{waiver_id}?pdf=false"
      FakeWeb.register_uri(:get, path, :body => json_waiver_single_results)
      result = @client.get(waiver_id)

      expect(result[:waiver][:waiverId]).to eq(waiver_id)
      expect(result[:waiver][:participants].length).to eq(2)
      expect(result[:waiver][:customWaiverFields][:"58458759da897"][:value]).to eq ("Testing")
    end

    it "#get with pdf" do
      waiver_id = "Vzy8f6gnCWVcQBURdydwPT"
      path = "#{API_URL}/v4/waivers/#{waiver_id}?pdf=true"
      FakeWeb.register_uri(:get, path, :body => json_waiver_single_results)
      @client.get(waiver_id, true)
    end

  end
end