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
    @modules or={}
    @session.modules or={}
  "/_lazuli/console": if config.enable_console
    (require "lapis.console").make!
  else
    => "console disabled in config"
  "/_lazuli/migrate": if config.enable_web_migration
    =>
      migrations.create_migrations_table!
      migrations.run_migrations require "migrations"
  else
    => "web migration disabled in config"
  new: (...)=>
    @modules or={}
    super ...
  enable: (feature,forcelapis=false)=>
    if not forcelapis
      have,fn=pcall require, "lazuli.modules."..feature..".enabler"
      if have and type(fn)=="function"
        return fn @
    super feature
  superroute: (sub)=>
    App=@__parent
    for app_route in pairs App.__base
      if type(app_route) == "table"
        app_route_name = next app_route
        if app_route_name == @route_name
          return =>
            if sub
              sub @, App.__base[app_route](@)
            else
              App.__base[app_route](@)
