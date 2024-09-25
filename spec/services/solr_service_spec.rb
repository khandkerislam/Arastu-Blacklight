require 'rsolr'
require 'rails_helper'

RSpec.describe Solr::SolrService do
  let(:solr_endpoint) { 'test_endpoint' }
  let(:solr_service) { described_class.new(solr_endpoint) }
  let(:rsolr_instance) { instance_double(RSolr::Client) }

  before do
    allow(RSolr).to receive(:connect).and_return(rsolr_instance)
  end

  describe '#queue_documents' do
    let(:documents) { [{ id: '123', title: 'Test Book' }] }
    let(:success_response) { { "responseHeader" => { "status" => 0 } } }
    let(:failure_response) { { "responseHeader" => { "status" => 1 } } }

    context 'when adding documents succeeds' do
      before do
        allow(rsolr_instance).to receive(:add).and_return(success_response)
      end

      it 'queues documents and returns true' do
        expect(solr_service.queue_documents(documents)).to be true
      end
    end

    context 'when adding documents fails' do
      before do
        allow(rsolr_instance).to receive(:add).and_return(failure_response)
      end

      it 'raises a SolrIndexError and returns false' do
        expect(solr_service.queue_documents(documents)).to be false
      end

      it 'rescues from SolrIndexError' do
        expect { solr_service.queue_documents(documents) }.not_to raise_error
      end
    end
  end

  describe '#delete_queued_documents' do
    let(:document_ids) { ['123', '456'] }
    let(:success_response) { { "responseHeader" => { "status" => 0 } } }
    let(:failure_response) { { "responseHeader" => { "status" => 1 } } }

    context 'when deleting documents succeeds' do
      before do
        allow(rsolr_instance).to receive(:delete_by_id).and_return(success_response)
      end

      it 'deletes documents and returns true' do
        expect(solr_service.delete_queued_documents(document_ids)).to be true
      end
    end

    context 'when deleting documents fails' do
      before do
        allow(rsolr_instance).to receive(:delete_by_id).and_return(failure_response)
      end

      it 'raises a SolrIndexError and returns false' do
        expect(solr_service.delete_queued_documents(document_ids)).to be false
      end

      it 'rescues from SolrIndexError' do
        expect { solr_service.delete_queued_documents(document_ids) }.not_to raise_error
      end
    end
  end

  describe '#commit_queued_updates' do
    it 'commits queued updates' do
      expect(rsolr_instance).to receive(:commit)
      solr_service.commit_queued_updates
    end
  end

  describe '#rollback_queued_updates' do
    it 'rolls back queued updates' do
      expect(rsolr_instance).to receive(:rollback)
      solr_service.rollback_queued_updates
    end
  end

  describe '#handle_response' do
    let(:success_response) { { "responseHeader" => { "status" => 0 } } }
    let(:failure_response) { { "responseHeader" => { "status" => 1 } } }

    context 'when the response is successful' do
      it 'returns true' do
        expect(solr_service.handle_response(success_response)).to be true
      end
    end

    context 'when the response fails' do
      it 'raises a SolrIndexError' do
        expect { solr_service.handle_response(failure_response) }.to raise_error(Solr::SolrIndexError)
      end
    end
  end
end
