storage "file" {
  path = "/mnt/host/c/Users/Shri/DATA MIGRATION PROJECT/app-repo"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}
api_addr = "http://127.0.0.1:8200"