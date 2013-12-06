module Workers
  class PostToApp < Base
    sidekiq_options queue: :http_service
    def perform(callback, params)
      begin
        connection = Faraday.new
        connection.post callback, params
      rescue => e
      end
    end
  end
end
