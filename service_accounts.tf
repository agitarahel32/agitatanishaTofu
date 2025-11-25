###############################
# NGINX RBAC
###############################

resource "kubernetes_service_account" "nginx_sa" {
  metadata {
    name      = "nginx-sa"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name
  }
}

resource "kubernetes_role" "nginx_role" {
  metadata {
    name      = "nginx-role"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["secrets", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "nginx_binding" {
  metadata {
    name      = "nginx-binding"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.nginx_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nginx_sa.metadata[0].name
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name
  }
}

###############################
# WORDPRESS RBAC
###############################

resource "kubernetes_service_account" "wordpress_sa" {
  metadata {
    name      = "wordpress-sa"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }
}

resource "kubernetes_role" "wordpress_role" {
  metadata {
    name      = "wordpress-role"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    verbs          = ["get"]
    resource_names = ["mariadb-secret"]
  }
}

resource "kubernetes_role_binding" "wordpress_binding" {
  metadata {
    name      = "wordpress-binding"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.wordpress_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.wordpress_sa.metadata[0].name
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }
}

###############################
# MARIADB RBAC
###############################

resource "kubernetes_service_account" "mariadb_sa" {
  metadata {
    name      = "mariadb-sa"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }
}

resource "kubernetes_role" "mariadb_role" {
  metadata {
    name      = "mariadb-role"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }

  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    verbs          = ["get"]
    resource_names = ["mariadb-secret"]
  }
}

resource "kubernetes_role_binding" "mariadb_binding" {
  metadata {
    name      = "mariadb-binding"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.mariadb_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.mariadb_sa.metadata[0].name
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }
}
