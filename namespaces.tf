resource "kubernetes_namespace" "nginx_ns" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_namespace" "wordpress_ns" {
  metadata {
    name = "wordpress"
  }
}

resource "kubernetes_namespace" "mariadb_ns" {
  metadata {
    name = "mariadb"
  }
}

