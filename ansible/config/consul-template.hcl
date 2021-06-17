consul {
  address     = "localhost:8500"

  retry {
    enabled   = true
    attempts  = 12
    backoff   = "250ms"
  }
}

reload_signal = "SIGHUP"
kill_signal   = "SIGINT"
log_level     = "warn"

syslog {
  enabled     = true
}

template {
  source      = "/etc/consul-template.d/pgbouncer.ctmpl"
  destination = "/etc/pgbouncer/pgbouncer.ini"
  perms       = 0755
  command     = "systemctl restart pgbouncer.service"
}
