require "rsolr"
module Solr
  class SolrService
    def initialize(endpoint = ENV["FULL_SOLR"], options = {})
      @solr = RSolr.connect(url: endpoint, **options)
    end

    def handle_response(response)
      raise SolrIndexError, response unless response["responseHeader"]["status"] == 0
      true
    end

    def queue_documents(documents)
      response = @solr.add(documents)
      handle_response(response)
    rescue SolrIndexError => e
      rollback_queued_updates
      puts "Could not add documents to Solr Index, #{e.message}"
    end

    def delete_queued_documents(documents)
      response = @solr.delete_by_id documents
      handle_response(response)
    rescue SolrIndexError => e
      rollback_queued_updates
      puts "Could not delete documents from Solr Index, #{e.message}"
    end

    def commit_queued_updates
      @solr.commit
    end

    def rollback_queued_updates
      @solr.rollback
    end
  end

  class SolrIndexError < StandardError
    def initialize(msg = "Could not perform Solr operation")
      super(msg)
    end
  end
end
