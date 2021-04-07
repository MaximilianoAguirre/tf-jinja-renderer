#########################################################################################
# VERSION REQUIREMENTS
#########################################################################################

terraform {
  required_version = "~> 0.13.4"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}
