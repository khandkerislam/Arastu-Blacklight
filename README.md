
# Blacklight Demo

This is a sample Blacklight demo using a catalog of 5,000 books from the Seattle Library for search functionality.

### Live Demo

You can test the live version of the application here:  
**[Blacklight Demo](https://eltaess-arastu-f9a999eb5bf7.herokuapp.com/)**

### Local Setup

The local setup includes a preconfigured Solr index with 5,000 books. Follow the steps below to get the application running locally.

#### Dependencies

Have Docker installed and running

#### 1. Resolving Docker File Permissions (Optional)
If you encounter file permission issues with Docker, you may need to run the following commands within the project directory:

```bash
sudo chown -R 8983:8983 ./blacklight-core
sudo chmod -R 777 ./blacklight-core
```

#### 2. Running the Application
- In a terminal, run `docker compose up`. This will start the Redis server, PostgreSQL databases, and Solr index.
- In a separate terminal, run the Rails server with `rails s`.
- Apply any pending database migrations in another terminal by running `rails db:migrate`.
- Once everything is set up, the app should be accessible at `http://localhost:3000`.

#### 3. Search Example
Try searching for **Jane Austen** to explore the search functionality.
