dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/webhook_queues_client"

describe SmartwaiverWebhookQueuesClient do
  attr_reader :client, :api_key

  before do
    @api_key = "apikey"
    @client = SmartwaiverWebhookQueuesClient.new(@api_key)
  end

  describe "webhook_queues" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverWebhookQueuesClient)
    end

    it "#information" do
      path="#{API_URL}/v4/webhooks/queues"
      stub_request(:get, path).to_return(body: json_webhook_queues_information_results)

      response = @client.information
      expect(response[:type]).to eq('api_webhook_all_queue_message_count')
      expect(response[:api_webhook_all_queue_message_count][:account][:messagesTotal]).to eq(2)
      expect(response[:api_webhook_all_queue_message_count][:'template-4fc7d12601941'][:messagesTotal]).to eq(4)
    end

    it "#get_message"  do
        path="#{API_URL}/v4/webhooks/queues/account"
        stub_request(:get, path).to_return(body: json_webhook_queues_get_message_results)

        response = @client.get_message
        expect(response[:type]).to eq('api_webhook_account_message_get')
        expect(response[:api_webhook_account_message_get][:messageId]).to eq('9d58e8fc-6353-4ceb-b0a3-5412f3d05e28')
        expect(response[:api_webhook_account_message_get][:payload][:unique_id]).to eq('xyz')
        expect(response[:api_webhook_account_message_get][:payload][:event]).to eq('new-waiver')
    end

    it "#delete_message"  do
      message_id = 'x-y-z'
      path="#{API_URL}/v4/webhooks/queues/account/#{message_id}"
      stub_request(:delete, path).to_return(body: json_webhook_queues_delete_message_results)

      response = @client.delete_message(message_id)
      expect(response[:type]).to eq('api_webhook_account_message_delete')
      expect(response[:api_webhook_account_message_delete][:success]).to eq(true)
    end

    it "#get_template_message"  do
      template_id = 't1'
      path="#{API_URL}/v4/webhooks/queues/template/#{template_id}"
      stub_request(:get, path).to_return(body: json_webhook_queues_template_get_message_results)

      response = @client.get_template_message(template_id)
      expect(response[:type]).to eq('api_webhook_template_message_get')
      expect(response[:api_webhook_template_message_get][:messageId]).to eq('9d58e8fc-6353-4ceb-b0a3-5412f3d05e28')
      expect(response[:api_webhook_template_message_get][:payload][:unique_id]).to eq('xyz')
      expect(response[:api_webhook_template_message_get][:payload][:event]).to eq('new-waiver')
    end

    it "#delete_template_message"  do
      template_id = 't1'
      message_id = 'x-y-z'
      path="#{API_URL}/v4/webhooks/queues/template/#{template_id}/#{message_id}"
      stub_request(:delete, path).to_return(body: json_webhook_queues_template_delete_message_results)

      response = @client.delete_template_message(template_id, message_id)

      expect(response[:type]).to eq('api_webhook_template_message_delete')
      expect(response[:api_webhook_template_message_delete][:success]).to eq(true)
    end

  end
end
