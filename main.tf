/**
 * # AWS IAM MFA-enabled Admin role and group
 *
 * This is a module to create an admin role, group, and associated policies
 * necessary to enforce MFA usage. Users added to the admin group are allowed
 * to update their MFA devices, as well as rotate their own access keys via
 * API.
 */

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "admin_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "admin" {
  name               = "${var.role_name}"
  description        = "Admin role for ${var.role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.admin_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "assume_role_admin" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.admin.arn}"]
  }
}

resource "aws_iam_policy" "assume_role_admin" {
  name        = "AssumeRoleAdmin-${aws_iam_role.admin.name}"
  description = "Allow users/groups to assume the ${aws_iam_role.admin.name} admin role"
  policy      = "${data.aws_iam_policy_document.assume_role_admin.json}"
}

data "aws_iam_policy_document" "manage_mfa" {
  statement {
    sid = "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid = "AllowUsersToListMFADevicesandUsersForConsole"

    actions = [
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ListUsers",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "manage_mfa" {
  name   = "AllowUsersToManageTheirOwnVirtualMFADevice"
  policy = "${data.aws_iam_policy_document.manage_mfa.json}"
}

data "aws_iam_policy_document" "allow_change_creds" {
  statement {
    actions = [
      "iam:*AccessKey*",
    ]

    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"]
  }
}

resource "aws_iam_policy" "allow_change_creds" {
  name   = "AllowChangeCreds"
  policy = "${data.aws_iam_policy_document.allow_change_creds.json}"
}

resource "aws_iam_group" "admin" {
  name = "${var.group_name}"
}

resource "aws_iam_group_membership" "team" {
  name = "${var.group_name}-membership"

  users = ["${var.users}"]

  group = "${aws_iam_group.admin.name}"
}

resource "aws_iam_group_policy_attachment" "assume_role_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.assume_role_admin.arn}"
}

resource "aws_iam_group_policy_attachment" "manage_mfa_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.manage_mfa.arn}"
}

resource "aws_iam_group_policy_attachment" "allow_change_creds_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.allow_change_creds.arn}"
}
