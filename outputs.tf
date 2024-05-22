# outputs
output "key_pair_name" {
  description = "The name of the key pair generated for the EC2 instance."
  value       = module.key_pair.key_pair_name
}

output "ssm_parameter_arn" {
  description = "The Amazon Resource Name (ARN) of the SSM parameter used to store the EC2 instance key pair."
  value       = aws_ssm_parameter.ssm_ec2_keypair.arn
}

output "public_key_pem" {
  description = "Public key data in PEM (RFC 1421) format"
  value       = module.key_pair.public_key_pem
}

output "private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format"
  value       = module.key_pair.private_key_pem
  sensitive   = true
}