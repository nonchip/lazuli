import escape from require "lapis.util"
http = require "lapis.nginx.http"
import render_html from require "lapis.html"
import from_json,to_json from require "lapis.util"
import encode_base64,hmac_sha1 from require "lapis.util.encoding"

UsersModel=require "lazuli.modules.user_management.models.users"
YubiCloudModel=require "lazuli.modules.user_management.models.yubicloud"


frandom = nil
ranval=->
  frandom or= assert io.open "/dev/urandom", "rb"
  s = frandom\read 4
  assert s\len! == 4
  v = 0
  for i = 1, 4
    v = 256 * v + s\byte i
  return v


class YubiCloud
  new: (@app,@modulename,@config) =>
    @apiurl = @config.apiurl or "http://api.yubico.com/wsapi/2.0/verify?id=1&otp=$OTP$&nonce=$NONCE$&timestamp=1"
    @required = @config.required or false
    @takeControlOfForm = @takeControlOfForm or true

  fillUrl: (otp,nonce) =>
    @apiurl\gsub("%$OTP%$",escape otp)\gsub("%$NONCE%$",escape nonce)

  tryLogin: (params) =>
    if params.yubikey
      nonce=@mkNonce!
      query=@fillUrl params.yubikey, nonce
      res=http.simple query
      if res\find "status=OK", 1, true and res\find "nonce="..nonce, 1, true
        entry=YubiCloudModel\find idstr: params.yubikey\lower!\sub(-33)
        if entry
          return entry\get_user!, res
      return nil, "invalid OTP or unregistered, details: "..query.." => "..res
    if @required
      return nil, res
    else
      return false, res

  mkNonce: =>
    now=os.time!
    hash=now..encode_base64 hmac_sha1 now..ranval!,ranval!..now
    hash=hash\gsub "%/","_"
    hash\sub 1,20

  getLoginOkHtml:    => ""
  getLoginErrorHtml: => ""

  getLoginHtml: =>
    render_html ->
      div class: "pure-control-group yubigroup", ->
        label for: "yubikey", "YubiCloud:"
        input id: "yubikey", type: "yubikey", name: "yubikey", autocomplete: "off", placeholder: "YubiKey OTP", autofocus: @takeControlOfForm and "autofocus" or nil
        if @takeControlOfForm
          input type: "button", value: "X", id: "closeYubiKeyBtn"
      if @takeControlOfForm
        script ->
          raw [[
            document.getElementsByClassName("usernamegroup")[0].hidden=true
            document.getElementsByClassName("passwordgroup")[0].hidden=true
            document.getElementById("closeYubiKeyBtn").onclick=function(){
              document.getElementsByClassName("usernamegroup")[0].hidden=false
              document.getElementsByClassName("passwordgroup")[0].hidden=false
              document.getElementsByClassName("yubigroup")[0].hidden=true
              document.getElementById("username").focus()
            }
          ]]
