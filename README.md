
# Blacklight Demo

This is a sample Blacklight demo using a catalog of 5,000 books from the Seattle Library for search functionality.

### Live Demo

You can test the live version of the application here:  
**[Blacklight Demo](https://arastu-blacklight-5eca0da0b2ae.herokuapp.com/)**



### Local Setup

The local setup includes a preconfigured Solr index with 5,000 books. Follow the steps below to get the application running locally.

#### Dependencies 

Must have Docker installed and running on your machine

#### 1. Environment Setup
- Rename `.env-copy` to `.env` to ensure proper configuration.

#### 2. Resolving Docker File Permissions (Optional)
If you encounter file permission issues with Docker, you may need to run the following commands within the project directory:

```bash
sudo chown -R 8983:8983 ./blacklight-core
sudo chmod -R 777 ./blacklight-core
```

#### 3. Running the Application
- In a terminal, run `docker compose up` or `docker compose up -d` for a detached terminal. This will start the Rails application, Redis server, PostgreSQL databases, and Solr index.
- In a separate terminal if needed, apply any pending database migrations with `docker compose exec web rails db:migrate`.
- Once everything is set up, the app should be accessible at `http://localhost:3000`.

#### 4. Search Example
Try searching for **Jane Austen** to explore the search functionality.



### Starting From Scratch

The section below covers what you would need for an absolutely fresh setup or would like to configure your own library dataset for testing.

#### Pulling in your own data

This application uses the [Seattle Library Dataset available on Socratica](https://dev.socrata.com/foundry/data.seattle.gov/6vkj-f5xf).  To make any API requests you will need to make a developer account on the [Seattle Data website](https://data.seattle.gov/).

To make an API request to download books one would have to update the following keys in `.env`.  

```
COLLECTION_ENDPOINT='data.seattle.gov'
APP_TOKEN=''
DATA_IDENTIFIER=''
```

Create a new app token by going into developer settings on your Seattle Data Account.

The identifier for the Seattle Library dataset is `6vkj-f5xf` and can be found in the About this Dataset section on the [Socratica page](https://dev.socrata.com/foundry/data.seattle.gov/6vkj-f5xf) or at the end of the JSON endpoint. 

Once you have these three envs set you can run the following rake task that will populate a new `collection.json` file with your collection of books.

Run the following rake task `docker compose exec web rake books:download_collection` to download 5000 books from the dataset.

#### Populating the database

If you haven't already, make sure you run migrations `docker compose exec web rails db:migrate`

> [!WARNING]
> Run the following rake tasks **one after the other** in order to populate the necessary tables.


The first task will create tables and entries for authors, publishers, subjects and collections

The second task will create books and their associations with subjects and isbns

```
docker compose exec web rake books:populate
docker compose exec web rake books:populate_books
```

#### Uploading documents to Solr 

> [!WARNING]
> Trying to upload documents that share IDs with existing documents in the Index will cause an error.
> Use the Solr Dashboard at `http://localhost:8983/` to delete all documents that will cause an existing ID error.

To upload documents to Solr, run the following rake task
`docker compose exec web rake books:index_books` 

Start sidekiq with 
`docker compose exec web bundle exec sidekiq`

You can check the status of your jobs at `http:localhost:3000/sidekiq` 

The Solr Dashboard is available at `http://localhost:8983/`

#### Solr Schema 

Changes to the Solr Schema can be made in the `./blacklight-core/conf/managed-schema.xml`
Changes to the Solr Config can be made in the `./blacklight-core/conf/solrconfig.xml`

#### Run Tests

You can run the RSpec suite with `docker compose exec web rspec`
