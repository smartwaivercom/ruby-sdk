dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/webhook_client"

describe SmartwaiverWebhookClient do
  attr_reader :client, :api_key

  before do
    @api_key = "apikey"
    @client = SmartwaiverWebhookClient.new(@api_key)
  end

  describe "webhooks" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverWebhookClient)
    end

    it "#configuration" do
      path="#{API_URL}/v4/webhooks/configure"
      stub_request(:get, path).to_return(body: json_webhook_configuration_results)

      response = @client.configuration
      expect(response[:webhooks].length).to eq(2)
    end

    it "#configure" do
      endpoint="http://requestb.in/1ajthro1"
      email_validation_required="yes"

      path="#{API_URL}/v4/webhooks/configure"
      stub_request(:put, path).to_return(body: json_webhook_configuration_results)

      response = @client.configure(endpoint, email_validation_required)
      expect(response[:webhooks][:endpoint]).to eq(endpoint)
      expect(response[:webhooks][:emailValidationRequired]).to eq(email_validation_required)
    end

    it "#delete" do
      path="#{API_URL}/v4/webhooks/configure"
      stub_request(:delete, path).to_return(body: json_webhook_delete_results)

      response = @client.delete

      expect(response[:webhooks]).to eq({})
    end

    it "#resend" do
      waiver_id = 'xyz'
      path="#{API_URL}/v4/webhooks/resend/#{waiver_id}"
      stub_request(:put, path).to_return(body: json_webhook_resend_results)

      response = @client.resend(waiver_id)
      expect(response[:webhooks_resend][:success]).to eq(true)
    end
  end
end
