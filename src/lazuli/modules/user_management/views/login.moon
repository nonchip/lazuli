import Widget from require "lapis.html"

class login extends Widget
  content: =>
    h1 "Login"
    form action: @url_for("lazuli_modules_usermanagement_login_do"), method: "post", class: "pure-form pure-form-aligned", ->
      input type: "hidden", name: "csrf_token", value: @lazuli_modules_usermanagement_csrf_token
      fieldset ->
        div class: "pure-control-group", ->
          label for: "username", "Username:"
          input id: "username",name: "username"
        div class: "pure-control-group", ->
          label for: "password", "Password:"
          input id: "password", type: "password", name: "password"
        div class: "pure-controls", ->
          input type: "submit", class: "pure-button pure-button-primary"
