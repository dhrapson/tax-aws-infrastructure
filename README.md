# Tax Basic Infrastructure

This repository holds the definition for the base infrastructure per AWS account

## Prerequisites

The infrastructure definitions are all in terraform, so you will require a local terraform CLI in order to run them.

## Per-integrator infrastructure

The files held under integrator can be run as follows:

```
cd integrator
TF_VAR_access_key='the_key_id' \
TF_VAR_secret_key='the_secret_key' \
TF_VAR_integrator_name='the_name' \
TF_VAR_client_name='the_client_name' \
TF_VAR_otherclient_name='the_other_client' \
TF_VAR_e2eclient_name='the_e2e_client' \
terraform [plan|apply]
```
