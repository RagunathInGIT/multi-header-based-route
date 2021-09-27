# multi-header-based-route

## Overview
This Plugin will examine the incoming list of headers and based on the combination, plugin will route the call to different upstream/target endpoints. Plugin can accept either AND or OR operators and not both at the same time for the incoming transaction.


## Supported Kong Releases
Kong >= 1.0.x

## Installation
Recommended:

git clone https://github.com/RagunathInGIT/multi-header-based-route.git /path/to/kong/plugins/multi-header-based-route <br/>
cd /path/to/kong/plugins/multi-header-based-route<br/>
luarocks make *.rockspec

## Configurations
### Plugin properties

| **Properties**        | **Type**          | **Description**  |
| ------------- |:-------------:| :-----|
| headerdetails     | Array of Strings | *It should follow the below pattern* <br/> header_name\|header_values:target_1 <br/> header_name\|header_values:target_1 <br/> header_name\|header_values:target_2 <br/> header_name\|header_values:target_2 <br/> ........ <br/> header_name\|header_values:target_n|
| targetdetails     | Array of Strings      |   *It should follow the below pattern* <br/> target_1:target_host\|target_port <br/> target_2:target_host\|target_port <br/>......... <br/>target_n:target_host\|target_port <br/>
| operator | string      |   AND or OR |
| header_count | number      |   specifies the count of header elements to consider for routing |
| default_host | string      |   Endpoint to route if the combination is not met with the incoming headers |

### Sample config

curl --location --request POST 'http://localhost:8001/services/{service_name_or_service_id}/plugins' \
--data 'name=multi-header-based-route' \
--data 'config.default_host=mocktarget.apigee.net' \
--data 'config.header_count=2' \
--data 'config.operator=AND' \
--data 'config.headerdetails.list=channel|online:target_1' \
--data 'config.headerdetails.list=cardType|visa:target_1' \
--data 'config.headerdetails.list=channel|stores:target_2' \
--data 'config.headerdetails.list=cardType|master:target_2' \
--data 'config.targetdetails.list=target_1|stores:httpbin.org|443' \
--data 'config.targetdetails.list=target_2|master:mocktarget.apigee.net'

In the above sample, we are looking for the combination of couple of headers.

If channel=online && cardType=visa, route the call to httpbin.org
If channel=stores && cardType=master, route the call to mocktarget.apigee.net

If none matches, route it to default host configured.

Similar config can be applied with OR operator where if one of the element in the combination is met, plugin will route to the corresponding target reference.

## Maintainers
