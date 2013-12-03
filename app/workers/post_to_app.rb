module Workers
  class PostToApp < Base
    sidekiq_options queue: :http_service
    def perform(callback, params)
      begin
        connection = Faraday.new
        connection.get callback, params
      rescue => e
        raise e
      end
    end
  end
end
