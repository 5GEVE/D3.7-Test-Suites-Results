# Test 3 - Complete workflow

This script executes a ping between two VNFs, extracting the RTT, which results in the delay measurement. In this particular test, it is tested the interaction between the EEM, RC and VNFs. It is based on the example provided in the [following repository](https://github.com/5GEVE/5geve-rc/tree/master/delay).

In order to test it:

```sh
# 1. Modify the variables defined in robot/measureDelay.robot to fit in your scenario.

# 2. Execute the Robot Framework script.
robot measureDelay.robot
```
