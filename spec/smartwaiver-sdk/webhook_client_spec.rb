dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/webhook_client"

describe SmartwaiverWebhookClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "apikey"
    @client = SmartwaiverWebhookClient.new(@api_key)
  end

  describe "webhooks" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverWebhookClient)
    end

    it "#configuration" do
      path="#{API_URL}/v4/webhooks/configure"
      FakeWeb.register_uri(:get, path, :body => json_webhook_configuration_results)

      response = @client.configuration
      expect(response[:webhooks].length).to eq(2)
    end

    it "#configure" do
      endpoint="http://requestb.in/1ajthro1"
      email_validation_required="yes"

      path="#{API_URL}/v4/webhooks/configure"
      FakeWeb.register_uri(:put, path, :body => json_webhook_configuration_results)

      response = @client.configure(endpoint, email_validation_required)
      expect(response[:webhooks][:endpoint]).to eq(endpoint)
      expect(response[:webhooks][:emailValidationRequired]).to eq(email_validation_required)
    end

  end
end