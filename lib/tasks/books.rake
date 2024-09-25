require "json"
require "rsolr"
namespace :books do
  desc "Create JSON file with library collection data"
  task download_collection: :environment do
    library = LibraryCollection::Downloader.call
    json_data = JSON.pretty_generate(library)
    File.write("db/collection.json", json_data)
  end
  desc "Populate database with authors, subjects, collections and publishers for the first time"
  task populate: :environment do
    require "activerecord-import"

    file_contents = File.read("db/collection.json")
    library = JSON.parse(file_contents, symbolize_names: true)
    active_record_collection = Hash.new { |h, k| h[k] = [] }

    author_set = Set.new
    collections_set = Set.new
    publishers_set = Set.new
    subjects_set = Set.new

    authors = []
    collections = []
    publishers = []
    subjects = []

    library.each do |entry|
      # Handle authors
      if author_set.add?(entry[:author])
        authors << Author.new(full_name: entry[:author])
      end

      # Handle collections
      if collections_set.add?(entry[:itemcollection])
        collections << Collection.new(name: entry[:itemcollection])
      end

      # Handle publishers
      if publishers_set.add?(entry[:publisher])
        publishers << Publisher.new(name: entry[:publisher])
      end

      # Handle subjects
      entry[:subjects]&.split(",")&.each do |subject|
        if subjects_set.add?(subject.strip)
          subjects << Subject.new(name: subject.strip)
        end
      end
    end

    Author.import authors

    Collection.import collections

    Publisher.import publishers

    Subject.import subjects
  end
  desc "Populate database with Books, ISBNS and BookSubjects for the first time"
  task populate_books: :environment do
    require "activerecord-import"

    file_contents = File.read("db/collection.json")
    library = JSON.parse(file_contents, symbolize_names: true)

    authors = Author.all.index_by(&:full_name)
    collections = Collection.all.index_by(&:name)
    publishers = Publisher.all.index_by(&:name)
    subjects = Subject.all.index_by(&:name)

    books_to_import = []
    book_subjects_to_import = []
    isbns_to_import = []

    errors = []

    Book.transaction do
      library.each_slice(1000) do |batch|
        batch.each do |entry|
          book = Book.new(entry.except(:author, :subjects, :publisher, :isbn, :itemcollection, :publicationyear))

          book.publicationyear = entry[:publicationyear].split(",")[0].gsub(/[^\d]/, "").strip if entry[:publicationyear]
          book.author = authors[entry[:author]] if entry[:author]
          book.collection = collections[entry[:itemcollection]] if entry[:itemcollection]
          book.publisher = publishers[entry[:publisher]] if entry[:publisher]

          if book.valid?
            if entry[:subjects]
              entry[:subjects].split(",").each do |subject_name|
                subject = subjects[subject_name.strip]
                if subject
                  book_subjects_to_import << BookSubject.new(subject: subject, book: book)
                end
              end
            end
            # Handle ISBNs
            if entry[:isbn]
              entry[:isbn].split(",").each do |isbn|
                isbn = isbn.strip
                existing_isbn = Isbn.find_by(isbn: isbn)
                isbns_to_import << Isbn.new(isbn: isbn, book: book) unless existing_isbn
              end
            end
            books_to_import << book

          else
            errors << book.errors.full_messages
          end
        end
        Book.import books_to_import
        BookSubject.import book_subjects_to_import
        Isbn.import isbns_to_import

        books_to_import.clear
        book_subjects_to_import.clear
        isbns_to_import.clear
      end
    end
  end
  desc "Delete all books from the database"
  task delete_books: :environment do
    ActiveRecord::Base.transaction do
      Isbn.delete_all
      BookSubject.delete_all
      Book.destroy_all
      Author.delete_all
      Publisher.delete_all
      Collection.delete_all
      Subject.delete_all
    end
  end
  desc "Index Books in Solr"
  task index_books: :environment do
    BatchSolrIndexJob.perform_async
  end
  desc "Commit in Solr"
  task solar_commit: :environment do
    SolrConnectionJob.perform_async
  end
  desc "Get schema"
  task
end
