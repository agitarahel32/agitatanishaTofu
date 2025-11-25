resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name
  }

  data = {
    "default.conf" = <<-EOF
      server {
          listen 80;
          server_name localhost;

          location / {
              root /usr/share/nginx/html;
              index index.html index.htm;
          }

          location /status {
              stub_status;
              allow 127.0.0.1;
              deny all;
          }
      }
    EOF
  }
}

resource "kubernetes_config_map" "wordpress_config" {
  metadata {
    name      = "wordpress-config"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  data = {
    WORDPRESS_DEBUG = "false"
  }
}

resource "kubernetes_config_map" "mariadb_config" {
  metadata {
    name      = "mariadb-config"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }

  data = {
    "my.cnf" = <<-EOT
      [mysqld]
      max_connections        = 200
      innodb_buffer_pool_size = 256M
      innodb_log_file_size    = 128M
    EOT
  }
}
