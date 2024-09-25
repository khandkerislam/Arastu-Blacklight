class BatchSolrIndexJob
  include Sidekiq::Job


  def perform(batch_size = 1000)
    batch = Sidekiq::Batch.new
    batch.description = "Uploading Books to Solr Index..."

    batch.on(:success, BatchSolrIndexJob::Created)

    batch.jobs do
      books = Book.where(processed: false).pluck(:id).in_groups_of(batch_size, false)
      books.each do |ids|
        SolrIndexJob.perform_async(ids)
      end
    end
  end

  class Created
    def on_success(status)
      puts "----"
      puts status
      puts "Uploaded Books to Solr Index"
    end
  end
end
