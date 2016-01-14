=>
  @include "lazuli.modules.user_management"
  @before_filter =>
    @modules.user_management or={}
    @session.modules.user_management or={}
    if not @modules.user_management.providers
      if type(config.modules.user_management)=="table" and type(config.modules.user_management.providers)=="table"
        @modules.user_management.providers={k,require(k)(@,k,v) for k,v in pairs config.modules.user_management.providers}
      else
        @modules.user_management.providers={}
    @modules.user_management.csrf_token = csrf.generate_token @, "lazuli_modules_usermanagement"
    if @session.modules.user_management.currentuser and not @modules.user_management.currentuser
      @modules.user_management.currentuser = Users\find @session.modules.user_management.currentuser
