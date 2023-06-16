# Template repo for IBM Cloud VPC Terraform projects

This repository contains a template for creating new Terraform projects for IBM Cloud VPC related deployments. It is intended to be used as a starting point for new projects.

## pre-commit hooks

The following pre-commit hooks are defined in the `.pre-commit-config.yaml` file:

- terraform_fmt: Syntax checking for Terraform
- detect-secrets: Ensure we don't commit anything sensitive

### Install pre-commit

```shell
pip install pre-commit
```

### Install hooks

```shell
pre-commit install
```

### Add Secret to detect-secrets

To add new secrets to the existing baseline, run the following command:

```shell
detect-secrets scan --baseline .secrets.baseline
```

This will rescan your codebase, and:

- Update/upgrade your baseline to be compatible with the latest version,
- Add any new secrets it finds to your baseline, and remove any secrets no longer in your codebase
- Preserve any labelled secrets you have.
