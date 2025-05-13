storage "file" {
  path = "/mnt/c/Users/Shri/Desktop/cloud-migration/app-repo/vault-data"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}
api_addr = "http://vault:8200"