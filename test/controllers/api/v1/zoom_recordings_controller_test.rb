require "test_helper"
require "minitest/mock"

class Api::V1::ZoomRecordingsControllerTest < ActionDispatch::IntegrationTest
  test "should start processing" do
    ENV["N8N_WEBHOOK_URL"] = "http://example.com"
    Faraday.stub :post, ->(url, payload) { Struct.new(:status).new(200) } do
      post "/api/v1/process_zoom_recording", params: { zoom_url: "https://zoom.us/rec/1" }
    end
    assert_response :success
  end

  test "should reject invalid url" do
    post "/api/v1/process_zoom_recording", params: { zoom_url: "invalid" }
    assert_response :bad_request
  end

  test "callback returns ok" do
    post "/api/v1/n8n_callback", params: {
      summary: "s", transcript: "t",
      bant: { budget: "b", authority: "a", need: "n", timing: "t" }
    }
    assert_response :success
  end
end
