class Example
  new: (@app,@modulename,@config) =>
  tryLogin: (params)         => false,"this example always returns false"
  getLoginHtml:                   => "<!-- example_false -->"
  getLoginOkHtml:                 => "<!-- example_false -->"
  getLoginErrorHtml:              => "<!-- example_false -->"
