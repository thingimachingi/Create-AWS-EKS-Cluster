provider "aws" {
  region = var.region
}

resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "clover-dev"
  }
}

resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name = "nginx-config"
    namespace = kubernetes_namespace.nginx_ingress.metadata.0.name
  }
  data = {
    proxy-body-size       = "64m"
    proxy-connect-timeout = "10s"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-ingress-controller"
    namespace = kubernetes_namespace.nginx_ingress.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-ingress-controller"
        }
      }

      spec {
        container {
          image = "nginx/nginx-ingress:3.0"
          name  = "nginx-ingress-controller"

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          args = [
            "/nginx-ingress-controller",
            "--configmap=nginx-ingress/nginx-config",
          ]
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-ingress"
    namespace = kubernetes_namespace.nginx_ingress.metadata.0.name
  }

  spec {
    selector = {
      app = "nginx-ingress-controller"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}
