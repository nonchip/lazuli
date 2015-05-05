lazuli = require "lazuli"
import capture_errors,assert_error from require "lapis.application"
import validate_functions, assert_valid from require "lapis.validate"
import hmac_sha1 from require "lapis.util.encoding"
import encode_base64 from require "lapis.util.encoding"
import cached from require "lapis.cache"

Users=require "lazuli.modules.user_management.models.users"

validate_functions.user_doesnt_exist = (username) ->
  u=Users\find username: username
  return not u, "user name already taken"
validate_functions.user_exists = (username) ->
  u=Users\find username: username
  return u and true or false, "user does not exist"

class UsersApplication extends lazuli.Application
  @path: "/users"
  @name: "users_"
  @before_filter =>
    if @session.user and not @current_user
      @current_user = Users\find @session.user
  [register: "/register"]: cached exptime: 60,[1]:=>
    render: require "lazuli.modules.user_management.views.register"
  [register_do: "/register/do"]: capture_errors{
    on_error: => render: require "lazuli.modules.user_management.views.register_do", status: 403
    =>
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
  [login: "/login"]: cached exptime: 60,[1]:=>
    render: require "lazuli.modules.user_management.views.login"
  [logout: "/logout"]: =>
    @session.user=nil
    @current_user=nil
    render: require "lazuli.modules.user_management.views.logout"
  [login_do: "/login/do"]: capture_errors{
    on_error: => render: require "lazuli.modules.user_management.views.login_do", status: 403
    =>
      assert_valid @params, {
        { "username", exists: true, min_length: 2, max_length: 250, user_exists: true}
        { "password", exists: true, min_length: 4 }
      }
      user = Users\find username: @params.username
      assert_error user.pwHMACs1==encode_base64(hmac_sha1(@params.password,user.username..@params.password)), "wrong password"
      @session.user=user.id
      @current_user=user
      render: require "lazuli.modules.user_management.views.login_do"
  }