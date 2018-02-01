
# AWS IAM MFA-enabled Admin role and group

This is a module to create an admin role, group, and associated policies
necessary to enforce MFA usage. Users added to the admin group are allowed
to update their MFA devices, as well as rotate their own access keys via
API.

## Example usage
```
resource "aws_iam_user" "bob" {
  name          = "bob"
  force_destroy = true
}

module "terraform-admin" {
  source     = "git::ssh://git@git.psu.edu/eio-tf-modules/aws-iam-mfa-admin.git"
  role_name  = "admin"
  group_name = "admin-users"
  users      = ["bob"]
}
```



  [36mvar.group_name[0m (required)
  [90mName of the admin group[0m

  [36mvar.role_name[0m (required)
  [90mName of the admin role[0m

  [36mvar.users[0m (<list>)
  [90mList of users to add to admin group[0m



  [36moutput.group_arn[0m
  [90mARN of the created admin group[0m

  [36moutput.group_id[0m
  [90mID of the created admin group[0m

  [36moutput.group_name[0m
  [90mName of the created admin group[0m

  [36moutput.role_arn[0m
  [90mARN of the created admin role[0m

  [36moutput.role_id[0m
  [90mID of the created admin role[0m

  [36moutput.role_name[0m
  [90mName of the created admin role[0m



