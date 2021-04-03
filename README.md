# tf-jinja-renderer

Terraform module that expands terraform core template capacities by allowing to render [Jinja](https://jinja.palletsprojects.com/en/2.11.x/) templates.

## Terraform versions

Terraform 0.13 and newer

## Usage

```hcl
module "jinja" {
    source =

    jinja_template = "${path.module}/jinja_template.yaml"
    data           = "${path.module}/data.json"

  filters = [
    "${path.module}/filters.py"
  ]
}
```

## Requirements

| Name        | Version   |
| ----------- | --------- |
| `terraform` | ~> 0.13.4 |
| `external`  | ~> 1.2    |

In addition to terraform and providers, this modules requires [`jq`](https://stedolan.github.io/jq/) and [`docker`](https://www.docker.com/) to be installed (and running in the case of docker).

## Inputs

| Name             | Description                                | Type         | Default        | Required |
| ---------------- | ------------------------------------------ | ------------ | -------------- | :------: |
| `jinja_template` | Path to the jinja template file            | string       | -              |  `yes`   |
| `data`           | Path to data file                          | string       | -              |  `yes`   |
| `filters`        | List of paths filters files (.py)          | list(string) | []             |   `no`   |
| `docker_tag`     | Tag to apply to docker image running jinja | string       | "jinja:latest" |   `no`   |

## Outputs

| Name                | Description       |
| ------------------- | ----------------- |
| `rendered_template` | Rendered template |
