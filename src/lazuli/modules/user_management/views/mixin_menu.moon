class FaviconMixin
  userManagementMixinMenu: (classes={})=>
    stateclass=@lazuli_modules_usermanagement_currentuser and "logged_in " or "logged_out "
    ul class: "lazuli module user_management mixin_menu "..stateclass..(classes.ul or ""), ->
      if @lazuli_modules_usermanagement_currentuser
        li class: "logout "..(classes.li or ""), ->
          a href:@url_for("lazuli_modules_usermanagement_logout"),class:(classes.a or ""), "Logout"
      else          
        li class: "login "..(classes.li or ""), ->
          a href:@url_for("lazuli_modules_usermanagement_login"),class:(classes.a or ""), "Login"
        li class: "register "..(classes.li or ""), ->
          a href:@url_for("lazuli_modules_usermanagement_register"),class:(classes.a or ""), "Register"
