resource "kubernetes_persistent_volume_claim" "mariadb_pvc" {
   metadata {
      name = "mariadb-pvc"
 }

   spec {
      access_modes = ["ReadWriteOnce"]
      resources {
        requests = {
	  storage = "5Gi"
        }
      }
   }
}
    
