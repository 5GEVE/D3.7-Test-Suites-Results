# Adapatation Layer MSO-LO Ever driver Tests

This folder contains the manual tests for the EVER driver component of the adaptation layer including the results.
Full list of tests, including their description, is provided in Deliverable D3.7.

## Pre-requisites and dependencies

tests will done using docker compose so to execute it just install docker -compose enad execute the file "docker-compose-test-ever.yml.

###Build the the docker apps
docker-compose --file docker-compose.test-ever.yml --project-name test-ever build

###Run the the docker apps
docker-compose --file docker-compose.test-ever.yml --project-name test-ever up

###Stop the the docker apps
docker-compose --file docker-compose.test-ever.yml --project-name test-ever down
