Users=require "lazuli.modules.user_management.models.users"
import dump from require "moonscript.util"

wasLoaded=false

=>
  @include "lazuli.modules.user_management" if not wasLoaded
  wasLoaded=true
  @before_filter =>
    @modules or={}
    @modules.user_management or={}
    @session.modules or={}
    @session.modules.user_management or={}
    if @session.modules.user_management.currentuser and not @modules.user_management.currentuser
      @modules.user_management.currentuser = Users\find @session.modules.user_management.currentuser
