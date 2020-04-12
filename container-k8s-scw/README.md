# Purpose
This module deploys a managed Kubernetes cluster on Scaleway with reasonable
defaults, autoscaling and autohealing enabled. It uses calico networking 
(arguably, the most popular one) and also deploys nginx as the ingress 
controller.

# How to use the module
Here is a simple way to use the module with all the defaults.

    module "container_k8s" {
    source  = "github.com/plukkido/terraform-modules/container-k8s-scw"

    name = "test-cluster"
    }


Alternately, you can alias providers so you can use a different provider config
for this module.

    variable "scaleway_access_key" {}
    variable "scaleway_secret_key" {}
    variable "scaleway_org_id" {}

    provider "scaleway" {
        alias = "special"

        access_key      = var.scaleway_access_key
        secret_key      = var.scaleway_secret_key
        organization_id = var.scaleway_org_id
        region          = "fr-par"
        zone            = "fr-par-1"
    }

    module "container_k8s" {
    source  = "github.com/plukkido/terraform-modules/container-k8s-scw"
    providers = {
        scaleway = "scaleway.special"
    }

    name = "test-cluster"
    }


# Known Limitations
At the time of writing this module Scaleway Kapsule is only available in the 
"fr-par" region.

# Inputs
## Required Inputs
These variables must be set in the module block when using this module.

**name** STRING
_The name of the cluster_

## Optional Inputs
These variables have default values and don't have to be set to use this module.
You may set these variables to override their default values.

**max** NUMBER (default is 2)
_The maximum size of the node pool_ 

**min** NUMBER (default is 1)
_The minimum size of the node pool_ 

**size** NUMBER (default is 1)
_The size of the initial node pool_ 

**type** STRING (default is "DEV1-M")
_The Scaleway machine type to use for the cluster node pool_ 
