Users=require "lazuli.modules.user_management.models.users"
import dump from require "moonscript.util"

=>
  f=io.open "/tmp/a","w"
  f\write dump @
  f\close!
  @modules or={}
  @include "lazuli.modules.user_management" if not @modules.user_management
  @modules.user_management or={}
  @before_filter =>
    @session.modules.user_management or={}
    if @session.modules.user_management.currentuser and not @modules.user_management.currentuser
      @modules.user_management.currentuser = Users\find @session.modules.user_management.currentuser
