class SolrIndexJob
  include Sidekiq::Job

  def perform(book_ids)

    books = Book.where(id: book_ids)
    return if books.empty?

    solr = Solr::SolrService.new

    solr_docs = books.map do |book|
      book.jsonify
    end

    solr.commit_queued_documents if solr.queue_documents(solr_docs)
  end
end
