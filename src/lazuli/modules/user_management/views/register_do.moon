import Widget from require "lapis.html"

class registerDo extends Widget
  content: =>
    if @errors
      h1 "Registration failed"
      ul ->
        for e in *@errors
          li e
      a href: @url_for("lazuli_modules_usermanagement_register"), "Back"
    else
      h1 "Registration successful"
