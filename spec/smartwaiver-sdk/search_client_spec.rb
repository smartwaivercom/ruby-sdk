dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/search_client"

describe SmartwaiverSearchClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "apikey"
    @client = SmartwaiverSearchClient.new(@api_key)
  end

  describe "keys" do
    it "#initialize" do
      expect(@client).to be_kind_of(SmartwaiverSearchClient)
    end

    it "#search empty" do
      path="#{API_URL}/v4/search"
      FakeWeb.register_uri(:get, path, :body => json_search_1_results)

      response = @client.search()

      expect(response[:search][:guid]).to eq("6jebdfxzvrdkd")
      expect(response[:search][:count]).to eq(652)
      expect(response[:search][:pages]).to eq(7)
      expect(response[:search][:pageSize]).to eq(100)
    end

    it "#search all params" do
      path="#{API_URL}/v4/search?templateId=xyz&fromDts=2018-01-01&toDts=2018-02-01&firstName=Rocky&lastName=RockChuck&verified=true&sort=asc&tag=new+customer"

      FakeWeb.register_uri(:get, path, :body => json_search_1_results)

      response = @client.search('xyz','2018-01-01', '2018-02-01','Rocky','RockChuck',true, SmartwaiverSearchClient::SEARCH_SORT_ASC, 'new customer')

      expect(response[:search][:guid]).to eq("6jebdfxzvrdkd")
      expect(response[:search][:count]).to eq(652)
      expect(response[:search][:pages]).to eq(7)
      expect(response[:search][:pageSize]).to eq(100)
    end

    it "#results" do

      path="#{API_URL}/v4/search/6jebdfxzvrdkd/results?page=1"

      FakeWeb.register_uri(:get, path, :body => json_search_2_results)

      response = @client.results('6jebdfxzvrdkd', 1)
      expect(response[:search_results].length).to eq(1)
    end

  end
end