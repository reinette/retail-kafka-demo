SET 'auto.offset.reset' = 'earliest';

-- Create a stream of products
CREATE STREAM products (
  id VARCHAR,
  brand VARCHAR,
  name VARCHAR,
  sale_price INT,
  rating DOUBLE,
  ts BIGINT
) WITH (
  KAFKA_TOPIC = 'products',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Create a stream of customers
CREATE STREAM customers (
  id VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR,
  email VARCHAR,
  phone VARCHAR,
  street_address VARCHAR,
  state VARCHAR,
  zip_code VARCHAR,
  country VARCHAR,
  country_code VARCHAR
) WITH (
  KAFKA_TOPIC = 'customers',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Create a stream of orders
CREATE STREAM transactions (
  order_id INT,
  product_id VARCHAR,
  customer_id VARCHAR,
  ts BIGINT
) WITH (
  KAFKA_TOPIC = 'transactions',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1,
  TIMESTAMP = 'ts'
);

-- Create a stream of website clicks
CREATE STREAM clickstream (
  product_id VARCHAR,
  user_id VARCHAR,
  view_time INT,
  page_url VARCHAR,
  ip VARCHAR,
  ts BIGINT
) WITH (
  KAFKA_TOPIC = 'clickstream',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1,
  TIMESTAMP = 'ts'
);

-- Create a stream of enriched transactions
CREATE STREAM transactions_enriched WITH (
  kafka_topic='transactions_enriched',
  partitions=1,
  value_format='JSON'
) AS
SELECT * FROM transactions
  INNER JOIN clickstream
    WITHIN 1 HOUR
    GRACE PERIOD 1 MINUTE
    ON transactions.customer_id = clickstream.user_id
EMIT CHANGES;

-- Inspiration, use Datagen for a quick demo of this:
-- https://developer.confluent.io/tutorials/omnichannel-commerce/confluent.html?ajs_aid=03c44684-5486-4f82-9772-48eea7e12e58&ajs_uid=860472