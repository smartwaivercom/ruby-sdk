dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/keys_client"

describe SmartwaiverKeysClient do
  attr_reader :client, :api_key

  before do
    @api_key = "apikey"
    @client = SmartwaiverKeysClient.new(@api_key)
  end

  describe "keys" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverKeysClient)
    end

    it "#create" do
      label = 'Ruby SDK'

      path="#{API_URL}/v4/keys/published"
      stub_request(:post, path).to_return(body: json_keys_create_results)

      response = @client.create(label)
      expect(response[:published_keys][:newKey][:key]).to eq("SPoyAc7mNHK8L6Yaq2s2Bu8UMcBEoyTvDeizmj94p6")
      expect(response[:published_keys][:newKey][:label]).to eq(label)
      expect(response[:published_keys][:keys].length).to eq(1)
    end

    it "#list" do
      path="#{API_URL}/v4/keys/published"
      stub_request(:get, path).to_return(body: json_keys_list_results)

      response = @client.list
      expect(response[:published_keys][:keys].length).to eq(1)
      expect(response[:published_keys][:keys][0][:key]).to eq("SPoyAc7mNHK8L6Yaq2s2Bu8UMcBEoyTvDeizmj94p6")
      expect(response[:published_keys][:keys][0][:label]).to eq("Ruby SDK")
    end
  end
end
