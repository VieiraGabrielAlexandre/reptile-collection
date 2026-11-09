# tflint configuration for all Terraform under infrastructure/terraform.
# The bundled "terraform" ruleset needs no plugin download.
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
