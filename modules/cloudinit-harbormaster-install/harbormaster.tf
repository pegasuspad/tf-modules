locals {
  # directory where the Harbormaster .yml file ultimately resides
  config_directory       = "${var.harbormaster_directory}/config"
  # full path to the harbormaster.yml file
  config_file            = "${local.config_directory}/hosts/${var.host_name}/_harbormaster.yml"
  # directory where harbormaster will store caches, data, repos, etc.
  workspace_directory    = "${var.harbormaster_directory}/workspace"

  packages = [
    "git", 
    "python3-pip",
  ]

  runcmd   = [
    "mkdir -p ${local.workspace_directory}",
    "git clone ${var.repository} ${local.config_directory}",
    "pip install docker-harbormaster",
    "systemctl daemon-reload",
    "systemctl enable harbormaster",
    "service harbormaster start",
  ]

  write_files = [
    {
      content = <<-EOT
        [Unit]
        Description=Run the Harbormaster updater
        Wants=harbormaster.timer

        [Service]
        ExecStart=/usr/local/bin/harbormaster run --working-dir "${local.workspace_directory}" --config "${local.config_file}"
        ExecStartPre=/usr/bin/git pull --rebase
        WorkingDirectory=${local.config_directory}

        [Install]
        WantedBy=multi-user.target
        EOT
      path        = "/etc/systemd/system/harbormaster.service"
      permissions = "0644"
    },
    {
      content = <<-EOT
        [Unit]
        Description=Run Harbormaster every minute.
        Requires=harbormaster.service

        [Timer]
        Unit=harbormaster.service
        OnUnitInactiveSec=${var.update_interval_minutes}m

        [Install]
        WantedBy=timers.target
        EOT
      path        = "/etc/systemd/system/harbormaster.timer"
      permissions = "0644"
    },
  ]

  harbormaster_task = {
    packages    = local.packages
    runcmd      = local.runcmd  
    write_files = local.write_files
  }
}
