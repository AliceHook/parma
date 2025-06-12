module Api
  module V1
    class ZoomRecordingsController < ApplicationController
      skip_forgery_protection

      # POST /api/v1/process_zoom_recording
      def process_zoom_recording
        zoom_url = params[:zoom_url]
        unless zoom_url.present? && zoom_url =~ URI::DEFAULT_PARSER.make_regexp
          Rails.logger.error("Invalid zoom_url: #{zoom_url}")
          return render json: { error: 'Invalid zoom_url' }, status: :bad_request
        end

        begin
          n8n_url = ENV.fetch('N8N_WEBHOOK_URL')
          response = Faraday.post(n8n_url, { zoom_url: zoom_url })
          Rails.logger.info("Sent to n8n: #{zoom_url} | Response status: #{response.status}")
        rescue => e
          Rails.logger.error("Failed to send to n8n: #{e.message}")
          return render json: { error: 'Failed to initiate processing' }, status: :internal_server_error
        end

        render json: { status: 'accepted' }, status: :ok
      end

      # POST /api/v1/n8n_callback
      def n8n_callback
        permitted = params.permit(:summary, :transcript, bant: %i[budget authority need timing])
        Rails.logger.info("n8n callback received: #{permitted.to_h}")
        head :ok
      end
    end
  end
end
