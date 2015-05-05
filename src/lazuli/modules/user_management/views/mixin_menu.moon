class FaviconMixin
  userManagementMixinMenu: ()->
    ul class: "lazuli module user_management mixin_menu "..(@lazuli_modules_usermanagement_currentuser and "logged_in" or "logged_out"), ->
      if @lazuli_modules_usermanagement_currentuser
        li class: "logout", ->
          a href:@url_for("lazuli_modules_usermanagement_logout"), "Logout"
      else          
        li class: "login", ->
          a href:@url_for("lazuli_modules_usermanagement_login"), "Login"
        li class: "register", ->
          a href:@url_for("lazuli_modules_usermanagement_register"), "Register"
