require 'rsolr'

class SolrConnectionJob
  include Sidekiq::Job

  BATCH_SIZE = 1000

  def perform(*args)
    #get batch of books

    solr = RSolr.connect(url: ENV['DOCKER_SOLR'])
    solr.commit
  end
end