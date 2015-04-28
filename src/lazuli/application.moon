lapis = require "lapis"

import after_dispatch from require "lapis.nginx.context"
import to_json from require "lapis.util"
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
  new: (...)=>
    super ...
