# Deploy with:
#   nomad job run -var="image_repo=ghcr.io/<user>/devops-intern-final" \
#                 -var="image_tag=<commit-sha>" nomad/nginx-app.nomad.hcl

variable "image_repo" {
  type        = string
  description = "Image repository in GHCR (lowercase)"
  default     = "ghcr.io/sahilransing2004-netizen/devops-intern-final"
}

variable "image_tag" {
  type        = string
  description = "Image tag to deploy (use the commit SHA from CI, not latest)"
}

job "nginx-app" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "2m"
    auto_revert       = true
  }

  group "web" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "15s"
      mode     = "delay"
    }

    reschedule {
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "10m"
      unlimited      = true
    }

    service {
      name     = "nginx-app"
      port     = "http"
      provider = "consul"
      tags     = ["web", "nginx"]

      check {
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "${var.image_repo}:${var.image_tag}"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
