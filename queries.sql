-- ecommerce.clickstream
-- ecommerce.transaction
-- ecommerce.transaction.item
-- retail.addresses
-- retail.customers
-- retail.customers.addresses
-- retail.organizations
-- retail.pos.transaction
-- retail.pos.transaction.item
-- retail.products
-- web.events

SET 'auto.offset.reset' = 'earliest';

-- CUSTOMERS

-- Project a stream of customers into ksqldb
CREATE OR REPLACE STREAM customers (
  SourceCustomerNumber VARCHAR KEY,
  FirstName VARCHAR,
  MiddleName VARCHAR,
  LastName VARCHAR,
  Email VARCHAR,
  State VARCHAR,
  Gender VARCHAR,
  MobileDeviceId VARCHAR,
  EmailOptInDate VARCHAR,
  UUID VARCHAR,
  WebAccountID VARCHAR,
  TwitterID VARCHAR,
  AccountID VARCHAR,
  DoNotEmail VARCHAR,
  DoNotCall VARCHAR,
  DoNotText VARCHAR,
  DoNotMail VARCHAR
) WITH (
  KAFKA_TOPIC = 'retail.customers',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Create table of latest customer data.
-- Emit updates to the table; this table can be spot-queried or subscribed-to.
-- The "WITH" creates the backing topic "retail.customers.distinct"
-- from the materialized stream "customers".
CREATE OR REPLACE TABLE customers_distinct WITH (
    KAFKA_TOPIC='retail.customers.distinct',
    KEY_FORMAT='JSON',
    VALUE_FORMAT='JSON'
  ) AS SELECT
    SourceCustomerNumber,
    LATEST_BY_OFFSET(FirstName) AS firstname,
    LATEST_BY_OFFSET(LastName) AS lastname,
    LATEST_BY_OFFSET(Email) AS email,
    LATEST_BY_OFFSET(State) AS state,
    LATEST_BY_OFFSET(Gender) AS gender,
    LATEST_BY_OFFSET(DoNotEmail) AS donotemail,
    LATEST_BY_OFFSET(DoNotCall) AS donotcall,
    LATEST_BY_OFFSET(DoNotText) AS donottext,
    LATEST_BY_OFFSET(DoNotMail) AS donotmail          
  FROM customers
  GROUP BY SourceCustomerNumber
EMIT CHANGES;

-- Project a stream of customers into ksqldb
CREATE OR REPLACE STREAM addresses (
  SourceAddressNumber VARCHAR KEY,
  AddressType VARCHAR,
  Address1 VARCHAR,
  City VARCHAR,
  Zip VARCHAR,
  State VARCHAR,
  Country VARCHAR
) WITH (
  KAFKA_TOPIC = 'retail.addresses',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Project a stream of customers-address xref into ksqldb
CREATE OR REPLACE STREAM customer_addresses (
  SourceAddressNumber VARCHAR KEY,
  SourceCustomerNumber VARCHAR
) WITH (
  KAFKA_TOPIC = 'retail.customers.addresses',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Get just the latest addresses
CREATE OR REPLACE TABLE addresses_distinct WITH (
  KAFKA_TOPIC='retail.addresses.distinct',
  KEY_FORMAT='JSON',
  VALUE_FORMAT='JSON'
  ) AS SELECT
    SourceAddressNumber,
    LATEST_BY_OFFSET(AddressType) AS addresstype,
    LATEST_BY_OFFSET(Address1) AS address,
    LATEST_BY_OFFSET(City) AS city,
    LATEST_BY_OFFSET(Zip) AS zip,
    LATEST_BY_OFFSET(State) AS state,
    LATEST_BY_OFFSET(Country) AS Country
  FROM addresses
  GROUP BY SourceAddressNumber
EMIT CHANGES;

-- Join the latest unique associated address with the latest unique customer
-- then enrich the customer record with their latest data. 
CREATE STREAM customers_enriched AS SELECT 
    customers_distinct.SourceCustomerNumber AS SourceCustomerNumber,
    customers_distinct.FirstName AS firstname,
    customers_distinct.LastName AS lastname,
    customers_distinct.Email AS email,
    customers_distinct.Gender AS gender,
    customer_addresses.SourceAddressNumber,
    addresses_distinct.AddressType AS addresstype,
    addresses_distinct.Address AS address,
    addresses_distinct.state AS state,
    addresses_distinct.zip AS zip,
    addresses_distinct.country AS country
  FROM customer_addresses
  JOIN customers_distinct ON customer_addresses.SourceCustomerNumber = customers_distinct.SourceCustomerNumber
  JOIN addresses_distinct ON customer_addresses.SourceAddressNumber = addresses_distinct.SourceAddressNumber;

-- Look for web events that are a checkout to find cookie; count number of
-- visits per checkout. Create a stream of visits, including SCN if we have it.
-- We're keying off cookie because that's what we have in common with
-- the clickstream and the transactions.
CREATE OR REPLACE STREAM clickstream (
  Cookie VARCHAR KEY,
  EventType VARCHAR,  
  Email VARCHAR,
  SourceCustomerNumber VARCHAR,
  SourceProductCategoryNumber VARCHAR,
  SearchTerm VARCHAR,
  Browser VARCHAR,
  DeviceType VARCHAR,
  OperatingSystem VARCHAR
) WITH (
  KAFKA_TOPIC = 'ecommerce.clickstream',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Example of a filter
SELECT * FROM clickstream WHERE EventType LIKE '%checkout%' EMIT CHANGES LIMIT 4;

-- TRANSACTIONS

-- Create a stream of ecommerce transactions
CREATE OR REPLACE STREAM transactions_ecommerce (
  SourceTransactionNumber VARCHAR KEY ,
  SourceOrganizationNumber VARCHAR,
  Total VARCHAR,
  SourceCustomerNumber VARCHAR
) WITH (
  KAFKA_TOPIC = 'ecommerce.transaction',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Create a stream of traditional transactions
CREATE OR REPLACE STREAM transactions_pos (
  SourceTransactionNumber VARCHAR KEY ,
  SourceOrganizationNumber VARCHAR,
  Total VARCHAR,
  SourceCustomerNumber VARCHAR
) WITH (
  KAFKA_TOPIC = 'retail.pos.transaction',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Let their powers combine!
-- Now one stream contains all purchases
CREATE STREAM transactions_combined AS
SELECT 'POS' AS source, SourceTransactionNumber, Total, SourceCustomerNumber
FROM transactions_pos;

INSERT INTO transactions_combined
SELECT 'ECOM' AS source, SourceTransactionNumber, Total, SourceCustomerNumber
FROM transactions_ecommerce;


-- PRODUCTS

-- Project a stream of products into ksqldb
CREATE OR REPLACE STREAM products (
  SourceProductNumber VARCHAR KEY,
  SourceProductCategoryNumber VARCHAR,
  Name VARCHAR,
  SalePrice DOUBLE,
  Color VARCHAR,
  AvailableQty VARCHAR,
  ListPrice DOUBLE
) WITH (
  KAFKA_TOPIC = 'retail.products',
  VALUE_FORMAT = 'JSON',
  PARTITIONS = 1
);

-- Product Categories table
CREATE TABLE categories WITH (
    KAFKA_TOPIC='retail.categories',
    KEY_FORMAT='JSON',
    VALUE_FORMAT='JSON'
) AS SELECT
    SourceProductNumber,
    LATEST_BY_OFFSET(SourceProductCategoryNumber) SourceProductCategoryNumber AS Category, 
FROM products
GROUP BY SourceProductCategoryNumber
EMIT CHANGES;




-- Use Datagen for a quick demo of this:
-- https://developer.confluent.io/tutorials/omnichannel-commerce/confluent.html?ajs_aid=03c44684-5486-4f82-9772-48eea7e12e58&ajs_uid=860472