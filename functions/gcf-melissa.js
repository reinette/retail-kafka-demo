/* The full POST-encoded data looks like this:
 * request: [{ 
 *   key: '764543', 
 *   value: '{Zip=94107, ..., AddressType=H}',
 *   topic: 'retail.addresses',
 *   partition: 0,
 *   offset: 1162,
 *   timestamp: 168254745936 
 * }]
 */

//const functions = require('@google-cloud/functions-framework');
const request = require('request');

exports.helloHttp = function helloHttp(req, res) {

  // What are we getting from Confluent? A POST form-encoded string.
  let topicData = req.body;
  let license = process.env.MELISSA_KEY;

  // Select the address components from our topic required to do a MELISSA lookup.
  // Response is a POST as a form-encoded object. There are libraries for doing this
  // this too, if you want to be all proper about it, but this gets it done.
  // See https://cloud.google.com/functions/docs/samples/functions-http-content
  let data = JSON.stringify(topicData[0].value).replace('"{','').replace('}"','');
  let responseItems = data.split(',');
  let zip = responseItems[0].split("=");
  let address = responseItems[17].split("=");
  let city = responseItems[18].split("=");
  let state = responseItems[25].split("=");
  let melissaUrl = 'https://property.melissadata.net/v4/WEB/LookupDeeds/?id='+license+'&format=JSON&t=RetailDemo&ff=';
  let fullAddress = address[1]+' '+city[1]+' '+state[1]+' '+zip[1];

  console.log(fullAddress);

  // Testing with Weather API
  // let weather = 'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true&hourly=temperature_2m';
  // TODO: add failure try/catch

  request.get(melissaUrl+fullAddress, function (error, response, body) {
    console.log('error:', error); // Print the error if one occurred 
    console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received 
    console.log('body:', body); // Prints the response of the request. 
    // Reply to the Kafka Success topic with the MELISSA response object.
    res.status(200).send(body);
  });

};
