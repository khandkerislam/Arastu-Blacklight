require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { create(:book) }
  let(:optional_associations_book) { create(:book, author: nil, publisher: nil, collection: nil) }

  describe 'validations' do
    it { should belong_to(:author).optional }
    it { should belong_to(:collection).optional }
    it { should belong_to(:publisher).optional }
    it { should have_many(:isbns) }
    it { should have_many(:book_subjects) }
    it { should have_many(:subjects).through(:book_subjects) }
  end

  describe 'after_save callback' do
    it 'calls index_in_solr after saving' do
      expect(book).to receive(:index_in_solr)

      book.save

      expect(book.processed).to be true
    end
  end

  describe '#jsonify' do
    it 'returns the correct JSON structure' do
      book_json = book.jsonify

      expect(book_json['title']).to eq(book.title)
      expect(book_json['author']).to eq(book.author.full_name)
      expect(book_json['publisher']).to eq(book.publisher.name)
      expect(book_json['collection']).to eq(book.collection.name)
      expect(book_json['subjects']).to match_array(book.subjects.pluck(:name))
      expect(book_json['isbns']).to match_array(book.isbns.pluck(:isbn))
    end

    it 'returns the correct JSON structure for a book with optional associations' do
      book_json = optional_associations_book.jsonify

      expect(book_json['title']).to eq(optional_associations_book.title)
      expect(book_json['author']).to eq("")
      expect(book_json['publisher']).to eq("")
      expect(book_json['collection']).to eq("")
      expect(book_json['subjects']).to match_array(optional_associations_book.subjects.pluck(:name))
      expect(book_json['isbns']).to match_array(optional_associations_book.isbns.pluck(:isbn))
    end
  end

  describe '#index_in_solr' do
    let!(:solr_service) { instance_double(Solr::SolrService) }
    let!(:solr_book) { build(:book) }
    let!(:failing_solr_book) { build(:book) }

    context 'when SolrService returns true' do
      before do
        allow(solr_service).to receive(:queue_documents).and_return(true)
        allow(solr_service).to receive(:commit_queued_updates)
      end

      it 'calls SolrService to queue documents and commit them' do
        expect(solr_book.processed).to be false

        expect(solr_service).to receive(:queue_documents).with(hash_including("title" => solr_book.title))
        expect(solr_service).to receive(:commit_queued_updates)

        solr_book.index_in_solr(solr_service)

        expect(solr_book.processed).to be true
      end
    end

    context 'when SolrService raises an error' do
      before do
        allow(solr_service).to receive(:queue_documents).and_return(false)
        allow(solr_service).to receive(:commit_queued_updates)
        allow(solr_service).to receive(:rollback_queued_updates)
      end

      it 'rescues from SolrIndexError and rolls back queued documents' do
        expect(failing_solr_book.processed).to be false

        expect(solr_service).to receive(:queue_documents).with(hash_including("title"=> failing_solr_book.title))
        expect(solr_service).not_to receive(:commit_queued_updates)
        expect(solr_service).to receive(:rollback_queued_updates)


        failing_solr_book.index_in_solr(solr_service)

        expect(failing_solr_book.processed).to be false
      end
    end
  end

  describe '#remove_from_index' do
    let!(:remove_from_index) { instance_double(Solr::SolrService) }
    let!(:delete_solr_book) { build(:processed_book) }
    let!(:failing_remove_solr_book) { build(:processed_book) }

    context 'when SolrService successfully queues documents for deletion' do
      before do
        allow(remove_from_index).to receive(:delete_queued_documents).and_return(true)
        allow(remove_from_index).to receive(:commit_queued_updates)
      end

      it 'calls SolrService to queue documents and commit the deletions' do
        expect(delete_solr_book.processed).to be true

        expect(remove_from_index).to receive(:delete_queued_documents).with(hash_including("title" => delete_solr_book.title))
        expect(remove_from_index).to receive(:commit_queued_updates)

        delete_solr_book.remove_from_index(remove_from_index)

        expect(delete_solr_book.processed).to be false
      end
    end

    context 'when SolrService raises an error' do
      before do
        allow(remove_from_index).to receive(:delete_queued_documents).and_return(false)
      end

      it 'rescues from SolrIndexError and rolls back queued documents' do
        expect(failing_remove_solr_book.processed).to be true

        expect(remove_from_index).to receive(:delete_queued_documents).with(hash_including("title"=> failing_remove_solr_book.title))
        expect(remove_from_index).to receive(:rollback_queued_updates)

        failing_remove_solr_book.remove_from_index(remove_from_index)

        expect(failing_remove_solr_book.processed).to be true
      end
    end
  end
end
