module LibraryCollection
  class CatalogEntryCreator < ApplicationService
    def initialize(data)
      @data = entry
    end

    def JSONToBook
      book = Book.new(@data.except(:author,:subjects,:publisher,:isbn,:itemcollection,:publicationyear))

      book.publicationyear = @data[:publicationyear].split(',')[0].gsub(/[^\d]/, '').strip if @data[:publicationyear]
      book.author = authors[@data[:author]] if @data[:author]
      book.collection = collections[@data[:itemcollection]] if @data[:itemcollection]
      book.publisher = publishers[@data[:publisher]] if @data[:publisher]
      
      book
    end
  end
end