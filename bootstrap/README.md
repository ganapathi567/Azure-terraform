## Bootstrapping a region in a subscription
It's assumed that a clean subscription is provided with the followings:
- learnedroutes VNET
- defaultroutes VNET
- necessary cli tooling is present on the developer's machine (01_prerequisites.sh)

Notes:
- Sometimes (when changing branches and environments) terraform state can get corrupted. As a safety check <br>
  the .terraform folder should be erased before changing environment.
- The bootstrap scripts shouldn't be run parallel on the same dev machine with the terraform scripts. Bootstrap <br>
  scripts should mostly use the logged in user's AZ credentials, while terraform scripts always require root <br>
  root service principal's AZ credentials. 

```bash
# create a storage account and a storage container where the terraform state (per subscription and region) is globally stored
./02_terrfaform_storage_account <dev|dev-euw|ppe|prod>

# create a root service principal for Terraform
./03_root_service_principal.sh <dev|dev-euw|ppe|prod>

# check that all permissions are assigned to the service principal (each permission should be marked with a green pictogram)
# Active Directory -> App Registrations -> API permissions
# WARNING: this process can fail multiple times as the underlying permission grant process is buggy (07/17/2020)
# If this happens the terraform apply needs to be changed to terraform destroy in the script to tear down the failed sp.
# the created root service principal needs to be added to the Active Directory's pipeline group

# create the pipeline keyvault in the appropriate subscription
# double check that the owner object ids correspond to the team members' Active Directory object ID
./04_pipeline_keyvault.sh <dev|dev-euw|ppe|prod>

# login as the root service principal so so that the infra keyvault will be ownerd by the root sp
./05_az_login.sh <dev|dev-euw|ppe|prod>

echo "Substitute the environment specific value into 06_stack_keyvault.sh before invoking it"
# create the infra keyvault and put the required secrets into it
./06_stack_keyvault.sh <dev|dev-euw|ppe|prod>
```
