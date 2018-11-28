dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/user_client"

describe SmartwaiverUserClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "apikey"
    @client = SmartwaiverUserClient.new(@api_key)
  end

  describe "user settings" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverUserClient)
    end

    it "#settings" do
      path="#{API_URL}/v4/settings"
      FakeWeb.register_uri(:get, path, :body => json_user_settings_results)

      response = @client.settings()

      expect(response[:settings][:console][:staticExpiration]).to eq("never")
      expect(response[:settings][:console][:rollingExpiration]).to eq("never")
      expect(response[:settings][:console][:rollingExpirationTime]).to eq("signed")
    end
  end
end