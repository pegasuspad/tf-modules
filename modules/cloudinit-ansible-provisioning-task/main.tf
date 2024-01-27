locals {
  ansible_vault_secret = try(var.vault_secret, null)
  ansible_vault_password_arguments = (
    local.ansible_vault_secret == null 
      ? []
      : ["--vault-password-file", "/etc/runtime-metadata/ansible-vault-secret"]
  )

  checkout_options = var.checkout == null ? {} : { checkout = var.checkout }

  galaxy_collection_actions = [
    for collection in var.galaxy_collections : [
      "ansible-galaxy",
      "collection",
      "install",
      collection
    ]
  ]

  galaxy_role_actions = [
    for role in var.galaxy_roles : [
      "ansible-galaxy",
      "role",
      "install",
      role
    ]
  ]

  galaxy_actions = concat(local.galaxy_collection_actions, local.galaxy_role_actions)

  extra_config = yamlencode({
    ansible = merge(
      {
        galaxy = {
          actions = local.galaxy_actions
        }
        # note in our current version of ubuntu, this _must_ be "pip", because installing with apt makes cloud-init fail
        # see: https://bugs.launchpad.net/ubuntu/+source/ansible/+bug/1995249
        install_method = "pip"
        package_name = "ansible-core"
        pull = {
          playbook_name = var.playbook
          url = var.git_url
          vault_password_file = "/etc/runtime-metadata/ansible-vault-secret"
        }
      },
      local.checkout_options
    )
  })

  write_files = local.ansible_vault_secret == null ? [] : [
    {
      content: local.ansible_vault_secret,
      owner: "root:root",
      path: "/etc/runtime-metadata/ansible-vault-secret",
      permissions: "0400",
    }
  ]

  task = {
    extra_config = local.extra_config
    packages     = ["python3-pip"]
    write_files  = local.write_files
  }
}
