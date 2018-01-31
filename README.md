# AWS IAM MFA-enabled Admin role and group

This is a module to create an admin role, group, and associated policies
necessary to enforce MFA usage. Users added to the admin group are allowed
to update their MFA devices, as well as rotate their own access keys via
API.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| group_name | Name of the admin group | string | - | yes |
| role_name | Name of the admin role | string | - | yes |
| users | List of users to add to admin group | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_arn | ARN of the created admin group |
| group_id | ID of the created admin group |
| group_name | Name of the created admin group |
| role_arn | ARN of the created admin role |
| role_id | ID of the created admin role |
| role_name | Name of the created admin role |

