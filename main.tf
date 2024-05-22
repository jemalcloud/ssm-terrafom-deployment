locals {
  name        = var.user_name
  region      = "us-east-1"
  environment = var.environment
  ssm_parameter_path = "/devstation/sshkey/${var.user_name}"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}


module "key_pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  version            = "2.0.0"
  key_name           = format("%s-kp", local.name)
  create_private_key = true
}

resource "null_resource" "write_public_key" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Writing public key to pubkeys/${module.key_pair.key_pair_name}.pem"
      echo '${module.key_pair.public_key_pem}' > ./pubkeys/${module.key_pair.key_pair_name}.pem
      echo "Public key content:"
      cat ./pubkeys/${module.key_pair.key_pair_name}.pem
    EOT
  }
}

resource "aws_ssm_parameter" "ssm_ec2_keypair" {
  name        = local.ssm_parameter_path
  description = "Stores the private key of ec2 key pair"
  type        = "SecureString"
  value       = module.key_pair.private_key_pem
  tags = {
    Environment = local.environment
    Name        = local.ssm_parameter_path
  }
}

resource "aws_instance" "example" {
  ami = "ami-0cdf717749cb64b94"  // Specify your desired AMI ID
  instance_type = "t2.micro"     // Specify your desired instance type
  key_name = module.key_pair.key_pair_name  // Name of the EC2 key pair
  user_data = data.template_file.ssh_setup_script.rendered

  // Add other configurations for your instance as needed

  // Depend on the null_resource to ensure the provisioner runs first
  depends_on = [null_resource.write_public_key]
}
