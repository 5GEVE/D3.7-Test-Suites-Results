# Test 3 - Publish operation

For this test, signalling topics must be created beforehand.

Note that the topics created for this operation are different from the ones reported in D3.7, because the DCM has evolved since the test reported in the deliverable were generated. The new topics are (where action can be either subscribe or unsubscribe):

```json
{
	"records": [
		{
			"value": {
				"topic": "uc.4.france_nice.application_metric.tracked_devices",
				"expId":"4", 
				"action":"subscribe", 
				"context": {
					"metricId": "tracked_devices",
					"metricCollectionType": "CUMULATIVE",
					"graph": "PIE",
					"name": "Number of total tracked devices",
					"unit": "devices",
					"interval": "5s"
				}
			}
		},
		{
			"value": {
				"topic":"uc.4.france_nice.application_metric.processed_records",
				"expId":"4",
				"action":"subscribe",
				"context": {
					"metricId": "processed_records",
					"metricCollectionType": "CUMULATIVE",
					"graph": "GAUGE",
					"name": "Number of total processed records",
					"unit": "records",
					"interval": "5s"
				}
			}
		},
		{ 
			"value": {
				"topic": "uc.4.france_nice.application_metric.tracking_response_time",
				"expId": "4",
				"action": "subscribe",
				"context": {
					"metricId": "tracking_response_time",
					"metricCollectionType": "GAUGE",
					"graph": "LINE",
					"name": "Max response time in milliseconds",
					"unit": "ms",
					"interval": "1s"
				}
			}
		},
		{
			"value": {
				"topic": "uc.4.france_nice.application_metric.tracking_memory_usage",
				"expId": "4",
				"action": "subscribe",
				"context": {
					"metricId": "tracking_memory_usage",
					"metricCollectionType": "GAUGE",
					"graph": "COUNTER",
					"name": "Memory usage in %",
					"unit": "%",
					"interval": "1s"
				}
			}
		}
	]
}
```

In order to test it:

```sh
# 1. Install REST library in your server.
pip install restinstance

# 2. Modify the variables defined in publish.robot to fit in your scenario.

# 3. Execute the Robot Framework script.
robot publish.robot
```
