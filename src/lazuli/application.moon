lapis = require "lapis"

import after_dispatch from require "lapis.nginx.context"
import to_json from require "lapis.util"
migrations=require "lapis.db.migrations"
config = (require "lapis.config").get!

class extends lapis.Application
  @before_filter =>
    if config.measure_performance
      after_dispatch ->
        print to_json ngx.ctx.performance
  "/_lazuli/console": if config.enable_console 
    (require "lapis.console").make!
  else
    => "console disabled in config"
  "/_lazuli/migrate": if config.enable_web_migration
    ->
      (require "moon").p config
      --migrations.create_migrations_table!
      --migrations.run_migrations require "migrations"
  else
    => "web migration disabled in config"
  new: (...)=>
    super ...
