# Test 3 - Publish operation

For this test, signalling topics must be created beforehand.

Note that the topics created for this operation are different from the ones reported in D3.7, because the DCM has evolved since the test reported in the deliverable were generated. The new topics are defined in both subscribe.json and unsubscribe.json files.

In order to test it:

```sh
# 1. Install REST library in your server.
pip install restinstance

# 2. Modify the variables defined in publish.robot to fit in your scenario.

# 3. Execute the Robot Framework script.
robot publish.robot
```
