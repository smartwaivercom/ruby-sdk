
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/smartwaiver-sdk/smartwaiver_base"

class SmartwaiverTest < SmartwaiverSDK::SmartwaiverBase
  def get_test(path)
    make_api_request(path, HTTP_GET)
  end

  def post_test(path, data)
    make_api_request(path, HTTP_POST, data)
  end

  def put_test(path, data)
    make_api_request(path, HTTP_PUT, data)
  end

  def delete_test(path)
    make_api_request(path, HTTP_DELETE)
  end

  def parse_response_body_test(data)
    parse_response_body(data)
  end

  def check_response_test(response)
    check_response(response)
  end

  def create_query_string_test(params)
    create_query_string(params)
  end
end

describe SmartwaiverSDK::SmartwaiverBase do

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "apikey"
  end

  describe "smartwaiver base object set up correctly" do
    it "has correct headers and accepts a custom endpoint" do
      test_endpoint = 'https://testapi.smartwaiver.com'
      client = SmartwaiverSDK::SmartwaiverBase.new(@api_key, test_endpoint)
      expect(client.instance_eval('@http').address).to eq("testapi.smartwaiver.com")
    end
  end

  describe "#version" do
    it "retrieves the current version of the API" do
      FakeWeb.register_uri(:get, "https://api.smartwaiver.com/version", :body => json_api_version_results)
      client = SmartwaiverSDK::SmartwaiverBase.new(@api_key)
      version = client.api_version

      expect(version[:version]).to eq(SmartwaiverSDK::VERSION)
    end
  end

  describe "#make_api_request" do
    before do
      @client = SmartwaiverTest.new(@api_key)
    end

    it "GET" do
      path = "#{API_URL}/get_test"
      FakeWeb.register_uri(:get, path, :body => json_base_results)
      @client.get_test(path)

      request = FakeWeb.last_request
      expect(request.method).to eq("GET")
      expect(request.body).to eq(nil)
      request.each_header do |key, value|
        case key
          when "user-agent"
            expect(value).to match(/^SmartwaiverAPI*/)
          when "sw-api-key"
            expect(value).to eq(@api_key)
        end
      end
    end

    it "POST" do
      path = "#{API_URL}/post_test"
      data = "{\"json\":\"data\"}"
      FakeWeb.register_uri(:post, path, :body => json_base_results)
      @client.post_test(path, data)

      request = FakeWeb.last_request
      expect(request.method).to eq("POST")
      expect(request.body).to eq(data)
      request.each_header do |key, value|
        case key
          when "user-agent"
            expect(value).to match(/^SmartwaiverAPI*/)
          when "sw-api-key"
            expect(value).to eq(@api_key)
          when "content-type"
            expect(value).to eq("application/json")
        end
      end
    end

    it "PUT" do
      path = "#{API_URL}/put_test"
      data = "{\"json\":\"data\"}"
      FakeWeb.register_uri(:put, path, :body => json_base_results)
      @client.put_test(path, data)

      request = FakeWeb.last_request
      expect(request.method).to eq("PUT")
      expect(request.body).to eq(data)
      request.each_header do |key, value|
        case key
          when "user-agent"
            expect(value).to match(/^SmartwaiverAPI*/)
          when "sw-api-key"
            expect(value).to eq(@api_key)
          when "content-type"
            expect(value).to eq("application/json")
        end
      end
    end

    it "DELETE" do
      path = "#{API_URL}/delete_test"
      FakeWeb.register_uri(:delete, path, :body => json_base_results)
      @client.delete_test(path)

      request = FakeWeb.last_request
      expect(request.method).to eq("DELETE")
      request.each_header do |key, value|
        case key
        when "user-agent"
          expect(value).to match(/^SmartwaiverAPI*/)
        when "sw-api-key"
          expect(value).to eq(@api_key)
        end
      end
    end
  end

  describe "#parse_response_body" do
    before do
      @client = SmartwaiverTest.new(@api_key)
    end

    it "parses valid json" do
      json = '{"version":4, "id":"8e82fa534da14b76a05013644ee735d2", "ts":"2017-01-17T15:46:58+00:00", "type":"test"}'
      data = @client.parse_response_body_test(json)

      expect(data[:version]).to eq(4)
      expect(data[:id]).to eq("8e82fa534da14b76a05013644ee735d2")
      expect(data[:ts]).to eq("2017-01-17T15:46:58+00:00")
      expect(data[:type]).to eq("test")
    end

    it "returns base parameters if json is invalid" do
      json = 'bad-json'
      data = @client.parse_response_body_test(json)

      expect(data[:version]).to eq(0)
      expect(data[:id]).to eq("")
      expect(data[:ts]).to eq("1970-01-01T00:00:00+00:00")
      expect(data[:type]).to eq("")
    end
  end

  describe "#create_query_string" do
    before do
      @client = SmartwaiverTest.new(@api_key)
    end

    it "create a valid query string" do
      params = {:a => "first", :b => "with space"}
      query_string = @client.create_query_string_test(params)

      expect(query_string).to eq("a=first&b=with+space")
    end
  end

  describe "#check_response" do
    it "HTTP 200" do
      path = "#{API_URL}/get_test"
      FakeWeb.register_uri(:get, path, :body => json_base_results)
      uri = URI.parse(path)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |req|
        response = req.get('/get_test')
        @client = SmartwaiverTest.new(@api_key)
        expect {@client.check_response_test(response)}.to_not raise_error
      end
    end

    it "HTTP Unauthorized" do
      path = "#{API_URL}/error_test"
      FakeWeb.register_uri(:get, path, :body => json_base_results, :status => ["401", "Unauthorized"])
      uri = URI.parse(path)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |req|
        response = req.get('/error_test')
        @client = SmartwaiverTest.new(@api_key)
        expect {@client.check_response_test(response)}.to raise_error(SmartwaiverSDK::BadAPIKeyError)
      end

    end

    it "HTTP NotAcceptable" do
      path = "#{API_URL}/error_test"
      FakeWeb.register_uri(:get, path, :body => json_base_results, :status => ["406", "Not Acceptable"])
      uri = URI.parse(path)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |req|
        response = req.get('/error_test')
        @client = SmartwaiverTest.new(@api_key)
        expect {@client.check_response_test(response)}.to raise_error(SmartwaiverSDK::BadFormatError)
      end
    end

    it "HTTP Client Error" do
      path = "#{API_URL}/error_test"
      FakeWeb.register_uri(:get, path, :body => json_base_results, :status => ["404", "Not Found"])
      uri = URI.parse(path)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |req|
        response = req.get('/error_test')
        @client = SmartwaiverTest.new(@api_key)
        expect {@client.check_response_test(response)}.to raise_error(SmartwaiverSDK::RemoteServerError)
      end
    end

    it "HTTP Server Error" do
      path = "#{API_URL}/error_test"
      FakeWeb.register_uri(:get, path, :body => json_base_results, :status => ["500", "Internal Server Error"])
      uri = URI.parse(path)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |req|
        response = req.get('/error_test')
        @client = SmartwaiverTest.new(@api_key)
        expect {@client.check_response_test(response)}.to raise_error(SmartwaiverSDK::RemoteServerError)
      end
    end
  end
end