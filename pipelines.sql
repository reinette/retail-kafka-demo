CREATE OR REPLACE STREAM "clickstream_purchasers" (Browser VARCHAR, Cookie VARCHAR KEY, DeviceType VARCHAR, Email VARCHAR, EventType VARCHAR, OperatingSystem VARCHAR, SearchTerm VARCHAR, SourceCustomerNumber VARCHAR, SourceProductCategoryNumber VARCHAR)
  WITH (kafka_topic='ecommerce.clickstream', partitions=1, key_format='JSON', value_format='JSON');

CREATE OR REPLACE STREAM "ecommerce_purchases"
  WITH (kafka_topic='ecommerce.clickstream.purchases', partitions=1)
  AS SELECT * FROM "clickstream_purchasers" WHERE EventType LIKE '%checkout%';

CREATE OR REPLACE STREAM "clickstream_purchasers_mobile"
  WITH (kafka_topic='ecommerce.clickstream.purchases.mobile', partitions=1)
  AS SELECT * FROM "ecommerce_purchases" WHERE DeviceType LIKE '%mobile%';