// Event Condition
// also productBrowsed, categoryBrowsed, onsiteSearch - not included, as we're generating these with different payloads.
String[] eventType  = ['emailSend', 'emailOpen', 'emailClick', 'emailBounce', 'emailSubscribe', 'emailUnsubscribe','cartUpdated', 'checkout','smsSubscribe', 'smsOpen', 'smsClick', 'smsUnsubscribe', 'smsSend', 'smsDeliver'];
int      eventTypeIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, eventType.size());

// Browser
String[] browserType  = ['firefox','chrome','safari','edge','ie'];
int      browserTypeIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, browserType.size());

// OS
String[] osType  = ['android','huawei','windows','samsung','sony','microsoft','apple'];
int      osTypeIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, osType.size());

// Device
String[] deviceType  = ['computer','mobile','tablet','game_console','media_reciever','wearable','unknown'];
int      deviceTypeIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, deviceType.size());

vars.put('mockValues.deviceType', deviceType[deviceTypeIdx]);
vars.put('mockValues.osType', osType[osTypeIdx]);
vars.put('mockValues.browserType', browserType[browserTypeIdx]);
vars.put('mockValues.eventType', eventType[eventTypeIdx]);

// Random email address in User Parameters
//${__changeCase(${__V(${given})}${__V(${family})},LOWER,)}${__Random(1,99)}@${__RandomString(10,aaabcdeeeeefghiiijklmnoooprstuuuvwy)}.com"