# Chat System APIs

## Rquirements
`docker` and `docker-compose`

## Dependencies
- Ruby 2.5.1
- Rails 5.2.3
- Mysql 5.7.19
- Elasticsearch 5.0.1
- Redis 3.3.5
- Sidekiq 4.2.10

## Steps
- Clone the repo
- Rename `database.sample.yml` file to be `database.yml` & `.env.sample` to `.env`
- Run `docker-compose up` in the terminal and you're ready to go (hopefully:)
- APIs can be accessed from localhost on port 3000
- Sidekiq admin UI can be accessed on `localhost:3000/queue`
- Execute `docker-compose run app rspec` to run the unit tests

## Endpoints
Use this [collection](https://www.getpostman.com/collections/cb1e1f24575fc7d46560) to test the API endpoints using Postman