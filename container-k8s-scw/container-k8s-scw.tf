# ------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These parameters must be supplied when consuming this module.
# ------------------------------------------------------------------------------

variable "name" {
  description = "The name of the cluster"
  type = string
}

# ------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "type" {
  description = "The Scaleway machine type to use for the cluster node pool"
  type = string
  default = "DEV1-M"
}

variable "size" {
  description = "The size of the initial node pool"
  type = number
  default = 1
}
variable "min" {
  description = "The minimum size of the node pool"
  type = number
  default = 1
}

variable "max" {
  description = "The maximum size of the node pool"
  type = number
  default = 2
}

# ------------------------------------------------------------------------------
# PROVIDERS
# The implementation providers configuration
# ------------------------------------------------------------------------------

provider "scaleway" {}

# ------------------------------------------------------------------------------
# RESOURCES
# The resources consisting this module
# ------------------------------------------------------------------------------

resource "scaleway_k8s_cluster_beta" "cluster" {
  name             = var.name
  version          = "1.18.1"
  cni              = "calico"
  enable_dashboard = false
  ingress          = "nginx"

  default_pool {
    node_type   = var.type
    size        = var.size
    autoscaling = true
    autohealing = true
    min_size    = var.min
    max_size    = var.max
  }

  autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "5m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
  }

  auto_upgrade {
    enable = true
    maintenance_window_start_hour = 2
    maintenance_window_day = "tuesday"
  }
}