module Workers
  class PostToApp < Base
    sidekiq_options queue: :http_service

    def perform(callback, params)
      connection = Faraday.new
      connection.post callback, params
    end
  end
end
