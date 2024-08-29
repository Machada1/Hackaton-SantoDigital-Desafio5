output "vm_instance_01_ip" {
  value = google_compute_instance.vm_instance_01.network_interface[0].network_ip
}

output "vm_instance_02_ip" {
  value = google_compute_instance.vm_instance_02.network_interface[0].network_ip
}

output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.http_forwarding_rule.ip_address
}
