import Widget from require "lapis.html"

class loginDo extends Widget
  content: =>
    if @errors
      h1 "Login failed"
      ul ->
        for e in *@errors
          li e
      a href: @url_for("lazuli_modules_usermanagement_login"), "Back"
    else
      h1 "Login successful"
      text "User id: "..@lazuli_modules_usermanagement_currentuser.id
