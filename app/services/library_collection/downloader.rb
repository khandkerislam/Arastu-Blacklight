require "soda/client"
module LibraryCollection
  class Downloader < ApplicationService
    def initialize(endpoint = nil, token = nil, identifier = nil)
      @endpoint = endpoint || ENV["COLLECTION_ENDPOINT"]
      @token = token || ENV["APP_TOKEN"]
      @identifier = identifier || ENV["DATA_IDENTIFIER"]
    end

    def call(limit = 5000)
      client = SODA::Client.new({ domain: @endpoint, app_token: @token })

      client.get(@identifier, :$limit => limit)
    end
  end
end
