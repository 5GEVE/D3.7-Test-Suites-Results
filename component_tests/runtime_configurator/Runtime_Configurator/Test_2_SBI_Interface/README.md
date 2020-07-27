# Test 2 - SBI Interface

This script executes a ping between two VNFs, extracting the RTT, which results in the delay measurement. In this particular test, only the interaction between Ansible and the VNFs is tested through a Robot Framework script, but the Robot Framework script is the same that the one used for Test 3. It is based on the example provided in the [following repository](https://github.com/5GEVE/5geve-rc/tree/master/delay).

In order to test it:

```sh
# 1. Modify the variables defined in robot/measureDelay.robot to fit in your scenario.

# 2. Execute the Robot Framework script.
robot measureDelay.robot
```
