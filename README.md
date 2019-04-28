# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

  2.5.3

- System dependencies

  ruby 2.5.3
  rails 5.2.3
  postgresql 9.2

- Configuration

- Database creation

  rails db:setup

- Database initialization

  rails db:seed (this is done by rails db:setup)

- How to run the WebCrawler bot
  rails db:seed

- Services (job queues, cache servers, search engines, etc.)

  RAILS=development bin/delayed_job restart

- Deployment instructions

  First, build the app
  Used as right now for test env

  - sudo docker build -t docker.peopleware.do:5000/minime .
  - sudo docker push docker.peopleware.do:5000/minime

  Run on server:

  - sudo docker pull docker.peopleware.do:5000/minime
  - sudo docker stop minime
  - sudo docker rm minime
  - sudo docker run -d -p 3001:3000 --restart=always --name minime docker.peopleware.do:5000/minime
