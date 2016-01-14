Users=require "lazuli.modules.user_management.models.users"

=>
  @include "lazuli.modules.user_management"
  @before_filter =>
    @modules or={}
    @modules.user_management or={}
    @session.modules.user_management or={}
    if @session.modules.user_management.currentuser and not @modules.user_management.currentuser
      @modules.user_management.currentuser = Users\find @session.modules.user_management.currentuser
