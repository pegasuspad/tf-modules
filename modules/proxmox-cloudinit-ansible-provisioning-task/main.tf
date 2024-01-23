locals {
  ansible_vault_secret = try(var.vault_secret, null)
  ansible_vault_password_arguments = (
    local.ansible_vault_secret == null 
      ? []
      : ["--vault-password-file", "/etc/runtime-metadata/ansible-vault-secret"]
  )

  ansible_arguments =join(" ", concat(
    [
      "--accept-host-key",
      "--inventory localhost,",
      "--purge",
      "--url",
      var.git_url,
    ],
    local.ansible_vault_password_arguments,
    [
      var.playbook,
      ">>/var/log/ansible.log",
      "2>&1",
    ]
  ))
}
