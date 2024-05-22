data "template_file" "ssh_setup_script" {
  template = file("${path.module}/scripts/userdata.sh")
  vars = {
    USER_NAME      = var.user_name
    PUBLIC_KEY_PEM = file("${path.module}/pubkeys/${var.user_name}-kp.pem")
  }
}