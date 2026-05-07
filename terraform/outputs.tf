output "master_public_ip" {
  value = aws_instance.k8s_control_plane.public_ip
}

output "worker_public_ip" {
  value = aws_instance.k8s_worker.public_ip
}