class Book < ApplicationRecord
  after_save :index_in_solr
  before_destroy :remove_from_index

  belongs_to  :author, optional: true
  belongs_to  :collection, optional: true
  belongs_to  :publisher, optional: true

  has_many    :isbns
  has_many    :book_subjects
  has_many    :subjects, through: :book_subjects

  def jsonify
    book_json = self.as_json(except: [ :created_at, :updated_at, :author_id, :collection_id, :publisher_id ])
    book_json["subjects"] = self.subjects.pluck(:name)
    book_json["isbns"] = self.isbns.pluck(:isbn)
    book_json["collection"] = self.collection&.name || ""
    book_json["author"] = self.author&.full_name || ""
    book_json["publisher"] = self.publisher&.name || ""
    book_json
  end

  def index_in_solr(solr = Solr::SolrService.new)
    book_json = self.jsonify
    response = solr.queue_documents(book_json)
    if response
      solr.commit_queued_updates
      self.write_attribute(:processed, true)
    else
      solr.rollback_queued_updates
    end
  end

  def remove_from_index(solr = Solr::SolrService.new)
    book_json = self.jsonify
    response = solr.delete_queued_documents(book_json)
    if response
      solr.commit_queued_updates
      self.write_attribute(:processed, false)
    else
      solr.rollback_queued_updates
    end
  end
end
