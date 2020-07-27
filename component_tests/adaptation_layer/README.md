# Robot Framework Tests for adaptation layer

## Description of tests

Tests for this component are included in [mso-lo](https://github.com/5GEVE/mso-lo).
Please check directory `adaptation_layer/robotframework`.

Tests included there validate the correct operation of the adaptation layer against real
instances of NFV orchestrator.
The following test suites are included:

- `MSO-LO-LCM-Workflow.robot` tests a complete workflow to instantiate and terminate a
Network Service, with status checking and intelligent waiting times.
The targeted NFVO can be configured by changing variables in `environment/variables.txt`.
- `MSO-LO-NFVO-Workflow.robot` tests operations to retrieve basic information about NFVOs
registered on the 5G-EVE platform.

Other `.robot` files include re-usable Robot Framework keywords.

## Test results

- [output-ever-driver](output-ever-driver): results executed for the EVER driver.
- [output-osm-driver](output-osm-driver): results executed with an OSM instance
- [output-onap-driver](output-onap-driver): results executed with an ONAP instance
- [output-nfvo-data](output-nfvo-data): results for NFVO information retrieval.
- [output-subscriptions](output-subscriptions): results for subscriptions' operations.
