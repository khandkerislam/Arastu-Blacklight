# frozen_string_literal: true

# Blacklight controller that handles searches and document requests
class CatalogController < ApplicationController
  include Blacklight::Catalog
  include Blacklight::Marc::Catalog


  # If you'd like to handle errors returned by Solr in a certain way,
  # you can use Rails rescue_from with a method you define in this controller,
  # uncomment:
  #
  # rescue_from Blacklight::Exceptions::InvalidRequest, with: :my_handling_method

  configure_blacklight do |config|
    # Solr URL endpoint (already configured in blacklight.yml)
    config.default_solr_params = {
      qt: "search",
      rows: 10,
      fl: "id, title, author, isbn, publisher, publicationyear, subject"
    }

    # Solr field configuration for search results/index view
    config.index.title_field = "title"
    config.index.display_type_field = "format"

    # Solr field configuration for document/show view
    config.show.title_field = "title"
    config.show.display_type_field = "format"

    # Configure default fields for search
    config.add_search_field "all_fields", label: "All Fields"
    config.add_search_field("title") do |field|
      field.solr_parameters = {
        qf: "${title_qf}",
        pf: "${title_pf}"
      }
    end

    config.add_search_field("author") do |field|
      field.solr_parameters = {
        qf: "${author_qf}",
        pf: "${author_pf}"
      }
    end

    config.add_search_field("subject") do |field|
      field.solr_parameters = {
        qf: "${subjects_qf}",
        pf: "${subjects_pf}"
      }
    end

    # Facets (filtering options in the sidebar)
    config.add_facet_field "author", label: "Author"
    config.add_facet_field "publisher", label: "Publisher"
    config.add_facet_field "subject", label: "Subject"
    config.add_facet_field "publicationyear", label: "Publication Year", range: true

    # Fields for display in index and show views
    config.add_index_field "author", label: "Author"
    config.add_index_field "isbn", label: "ISBN"
    config.add_index_field "publisher", label: "Publisher"
    config.add_index_field "publicationyear", label: "Publication Year"
    config.add_index_field "subject", label: "Subjects"

    config.add_show_field "author", label: "Author"
    config.add_show_field "isbn", label: "ISBN"
    config.add_show_field "publisher", label: "Publisher"
    config.add_show_field "publication_year", label: "Publication Year"
    config.add_show_field "subject", label: "Subjects"

    # # Sort options for the search results
    # config.add_sort_field 'score desc, publicationyear desc', label: 'Relevance'
    # config.add_sort_field 'publicationyear desc', label: 'Newest First'
    # config.add_sort_field 'publicationyear asc', label: 'Oldest First'
  end
end
