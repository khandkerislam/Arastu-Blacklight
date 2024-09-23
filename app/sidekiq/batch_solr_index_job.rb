class BatchSolrIndexJob
  include Sidekiq::Job

  BATCH_SIZE=1000

  def perform
    batch = Sidekiq::Batch.new
    batch.description = "Uploading Books to Solr Index..."

    batch.on(:success, BatchSolrIndexJob::Created)

    batch.jobs do
      books = Book.where(processed: false).pluck(:id).in_groups_of(BATCH_SIZE,false)
      books.each do |ids| 
        SolrIndexJob.perform_async(ids)
      end
    end
  end

  class Created
    def on_success(status)
      puts '----'
      puts status 
      puts "Uploaded Books to Solr Index"
    end
  end
end
