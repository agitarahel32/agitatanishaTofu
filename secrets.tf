##############################################
# SECRET: MARIADB (namespace mariadb)
##############################################

resource "kubernetes_secret" "mariadb_secret" {
  metadata {
    name      = "mariadb-secret"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }

  data = {
    "mariadb-password" = base64encode("siskamariadbpasswd")
  }

  type = "Opaque"
}


##############################################
# SECRET: MARIADB UNTUK WORDPRESS (namespace wordpress)
##############################################

resource "kubernetes_secret" "mariadb_secret_in_wordpress" {
  metadata {
    name      = "mariadb-secret"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  data = {
    "mariadb-password" = base64encode("siskamariadbpassword")
  }

  type = "Opaque"
}

