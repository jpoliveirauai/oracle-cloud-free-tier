output "instance_public_ip" {
  value       = oci_core_instance.aiostreams_server.public_ip
  description = "IP Público da instância do AIOStreams. Acesse via http://IP:3000"
}