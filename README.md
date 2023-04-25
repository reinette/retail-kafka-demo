README

This repo will let you spin up jMeter and begin sending Kafka produce calls and REST Produce calls to a Confluent Kafka cluster. What I have here is just a start -- adjust as you need, but this will work out of the box to give you an idea of the power of jMeter to help during load testing, data modelling, and local API development. There are many tools online that do a lot of the parts of the tests, but I love having it all in one place.

For actual load testing, you can run this headless -- and there are services like jMeter you can leverage for testing at enterprise scale.

JMETER:

Download Apache jMeter here: https://jmeter.apache.org/

Also requires jMeter plugin manager: https://jmeter-plugins.org/. Grab the following plugins after installing it:
- DI KafkaMeter
- Dummy Sampler
- HTTP Form Manager
- Custom JMeter Functions
- Custom Thread Groups
- Throughput Shaping Timer
- Variables from CSV File
- Kafka Support
- Kafka backend listener
- jpgc - Standard Set

There are also plugins for mocking MQTT, Elastic, Mongo, JDPC, and FTP data sources. It's fun, check it out!

THESE TOPICS:
ecommerce.clickstream
ecommerce.transaction
ecommerce.transaction.item
retail.addresses
retail.customers
retail.customers.addresses
retail.organizations
retail.pos.transaction
retail.pos.transaction.item
retail.products
web.events

MAKE THESE FILES:

jaas.conf:
org.apache.kafka.common.security.plain.PlainLoginModule required username='[CC_API_KEY]' password='[CC_SECRET]';

secrets.csv - note these keys may be the same or different for you, depending on your security setup.
CC_KEY,[CC_PRODUCER_KEY]
CC_SECRET,[CC_PRODUCER_SECRET]
CC_API_KEY,[CC_API_KEY]
CC_API_SECRET,[CC_API_SECRET]