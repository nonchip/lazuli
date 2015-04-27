{
  whitelist_globals: {
    ["config.moon"]: {
      "port"
      "password"
      "database"
      "postgres"
      "page_cache_size"
      "code_cache"
      "num_workers"
      "run_daemon"
      "session_name"
      "secret"
      "set"
      "backend"
      "measure_performance"
      "user"
      "host"
    }
    ["."]:{ "ngx" }
  }
}
