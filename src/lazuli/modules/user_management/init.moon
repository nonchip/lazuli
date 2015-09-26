lazuli = require "lazuli"
import capture_errors,assert_error from require "lapis.application"
import validate_functions, assert_valid from require "lapis.validate"
import hmac_sha1 from require "lapis.util.encoding"
import encode_base64 from require "lapis.util.encoding"
import cached from require "lapis.cache"
csrf = require "lapis.csrf"
config = (require "lapis.config").get!


Users=require "lazuli.modules.user_management.models.users"

validate_functions.user_doesnt_exist = (username) ->
  u=Users\find username: username
  return not u, "user name already taken"
validate_functions.user_exists = (username) ->
  u=Users\find username: username
  return u and true or false, "user does not exist"

class UsersApplication extends lazuli.Application
  @path: "/users"
  @name: "lazuli_modules_usermanagement_"
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
  [register: "/register"]: =>
    render: require "lazuli.modules.user_management.views.register"
  [register_do: "/register/do"]: capture_errors{
    on_error: => render: require "lazuli.modules.user_management.views.register_do", status: 403
    =>
      csrf.assert_token @, "lazuli_modules_usermanagement"
      assert_valid @params, {
        { "username", exists: true, min_length: 2, max_length: 250, user_doesnt_exist: true }
        { "password", exists: true, min_length: 4 }
        { "password_repeat", equals: @params.password, "passwords must match" }
      }
      user = Users\create {
        username: @params.username
        pwHMACs1: encode_base64(hmac_sha1(@params.password,@params.username..@params.password))
      }
      render: require "lazuli.modules.user_management.views.register_do"
  }
  [login: "/login"]: =>
    @providerHtml={k,v\getLoginHtml! for k,v in pairs @modules.user_management.providers}
    render: require "lazuli.modules.user_management.views.login"
  [logout: "/logout"]: =>
    @session.modules.user_management.currentuser=nil
    @modules.user_management.currentuser=nil
    render: require "lazuli.modules.user_management.views.logout"
  [login_do: "/login/do"]: capture_errors{
    on_error: =>
      @providerHtml={k,v\getLoginErrorHtml! for k,v in pairs @modules.user_management.providers}
      render: require "lazuli.modules.user_management.views.login_do", status: 403
    =>
      csrf.assert_token @, "lazuli_modules_usermanagement"
      assert_valid @params, {
        { "username", exists: true, min_length: 2, max_length: 250, user_exists: true}
        { "password", exists: true, min_length: 4 }
      }
      user = Users\find username: @params.username
      logged_in_ok=false
      user.logged_in_by_provider="fallback"
      user.logged_in_providers_tried={}
      for k,v in pairs @modules.user_management.providers
        ret,msg=v\tryLogin(user,@params)
        switch ret
          when true
            logged_in_ok=true
            user.logged_in_by_provider=k
            user.logged_in_providers_tried[k]={true,msg}
            break
          when false
            user.logged_in_providers_tried[k]={false,msg}
          when nil
            assert_error nil, msg
      if not logged_in_ok
        assert_error user.pwHMACs1==encode_base64(hmac_sha1(@params.password,user.username..@params.password)), "wrong password"
      @session.modules.user_management.currentuser=user.id
      @modules.user_management.currentuser=user
      @providerHtml={k,v\getLoginOkHtml! for k,v in pairs @modules.user_management.providers}
      render: require "lazuli.modules.user_management.views.login_do"
  }
