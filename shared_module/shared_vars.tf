locals {
  env ="${terraform.workspace}"

  hamiidenv= {
    default = "amiid_default"
    stagging = "amiid_stagging"
    production = "amiid_production"


  }

  env_suffix = "${lookup(local.hamiidenv,local.env)}"
}

output "env_suffix_env" {

  value = "${local.hamiidenv}"
}