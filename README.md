# tf-jinja-renderer

Terraform module that expands terraform core template capacities by allowing to render [Jinja](https://jinja.palletsprojects.com/en/2.11.x/) templates.

## Terraform versions

Terraform 0.13 and newer

## Usage

```hcl
module "tf-jinja-renderer" {
  source = "github.com/MaximilianoAguirre/tf-jinja-renderer"

  jinja_template = <<EOF
    server {
      listen 80;
      server_name {{ nginx.hostname }};

      root {{ nginx.webroot }};
      index index.htm;
    }
    EOF

  data = <<EOF
    {
        "nginx":{
            "hostname": "localhost",
            "webroot": "/var/www/project"
        }
    }
    EOF

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

| Name                    | Description                                | Type         | Default                                    | Required |
| ----------------------- | ------------------------------------------ | ------------ | ------------------------------------------ | :------: |
| `jinja_template`        | Path to the jinja template file            | string       | -                                          |  `yes`   |
| `data`                  | Path to data file                          | string       | -                                          |  `yes`   |
| `filters`               | List of paths to filters files (.py)       | list(string) | []                                         |   `no`   |
| `allow_undefined`       | Allow undefined values in jinja            | bool         | false                                      |   `no`   |
| `data_format`           | Data format                                | string       | "json"                                     |   `no`   |
| `docker_tag`            | Tag to apply to docker image running jinja | string       | "maximilianoaguirre/tf-jinja-renderer:1.0" |   `no`   |
| `docker_container_name` | Prefix used for the docker container       | string       | "tf-jinja-renderer"                        |   `no`   |

## Outputs

| Name                | Description       |
| ------------------- | ----------------- |
| `rendered_template` | Rendered template |
