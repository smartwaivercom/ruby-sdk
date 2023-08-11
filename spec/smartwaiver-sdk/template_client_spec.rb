dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/template_client"

describe SmartwaiverTemplateClient do
  attr_reader :client, :api_key

  before do
    @api_key = "apikey"
    @client = SmartwaiverTemplateClient.new(@api_key)
  end

  describe "templates" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverTemplateClient)
    end

    it "#list" do
      path = "#{API_URL}/v4/templates"
      stub_request(:get, path).to_return(body: json_template_list_results)
      result = @client.list

      expect(result[:templates].length).to eq(3)
    end

    it "#get" do
      template_id = "586ffe15134bc"
      path = "#{API_URL}/v4/templates/#{template_id}"
      stub_request(:get, path).to_return(body: json_template_single_results)
      result = @client.get(template_id)
      expect(result[:template][:templateId]).to eq(template_id)
    end
  end
end
