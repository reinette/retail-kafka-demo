# Retail Kafka Demo

This repo will let you spin up jMeter and begin sending Kafka produce calls and REST Produce calls to a Confluent Kafka cluster. What I have here is just a start -- adjust as you need, but this will work out of the box to give you an idea of the power of jMeter to help during load testing, data modelling, and local API development.

There are many tools online that do a lot of the parts of the tests, like Postman collections for mocking up request flows, but there's something to be said for having all your scenarios all in one place. The benefit of jMeter is that you can be very specific about throughputs and weights of different scenarios; for actual load testing, you can also run it headless -- there are services like jMeter you can leverage for testing at enterprise scale across a fleet of containers.

## Install jMeter:

Download Apache jMeter here: https://jmeter.apache.org/

Also requires jMeter plugin manager: https://jmeter-plugins.org/. Grab the following plugins after installing it:
* DI KafkaMeter
* Dummy Sampler
* HTTP Form Manager
* Custom JMeter Functions
* Custom Thread Groups
* Throughput Shaping Timer
* Variables from CSV File
* Kafka Support
* Kafka backend listener
* jpgc - Standard Set

There are also plugins for mocking MQTT, Elastic, Mongo, JDPC, and FTP data sources. It's fun, check it out!

## Create these topics:
* ecommerce.clickstream
* ecommerce.transaction
* ecommerce.transaction.item
* retail.addresses
* retail.customers
* retail.customers.addresses
* retail.organizations
* retail.pos.transaction
* retail.pos.transaction.item
* retail.products
* web.events

## Add these files

... to your project's root directory.

### jaas.conf:
org.apache.kafka.common.security.plain.PlainLoginModule required username='[CC_API_KEY]' password='[CC_SECRET]';

### secrets.csv
CC_KEY,[CC_PRODUCER_KEY]

CC_SECRET,[CC_PRODUCER_SECRET]
