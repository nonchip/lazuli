import Widget from require "lapis.html"
import slugify, to_json from require "lapis.util"


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
      text "User id: "..@modules.user_management.currentuser.id
    div class: "providers", ->
      for k,v in pairs @providerHtml
        div class: "provider "..slugify(k), ->
          raw v
    raw "<!--"..to_json(@modules.user_management.currentuser.logged_in_providers_tried).."-->"