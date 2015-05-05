# lazuli - a lapis framework
## command line
### first time setup

    ./setup.zsh

this installs the dependencies (and some wrappers) locally, thanks to magic I'm not going to explain, just read the source if you want to.

### setting up your app

edit `config.moon` or create `custom_config.moon` (which has priority over `config.moon` if it exists)

### running your app

    ./mk <environment>
    ./lapis server <environment>

where `<environment>` may be `development`, `test` or `production`.

### rebuilding/upgrading your app

after you made some changes, you might want to make lapis reload your stuff on the fly:

    ./mk <environment>

### stopping the server

#### in `development` or `test` mode

just press ctrl+c

#### in `production` mode

    ./lapis term

## webserver config
###apache2

    <VirtualHost *:80>
            ServerName <hostname>
            ProxyPreserveHost On
            ProxyPass / http://127.0.0.1:<port>/
            ProxyPassReverse / http://127.0.0.1:<port>/
    </VirtualHost>

where `<hostname>` is the FQDN to handle and `<port>` is the port specified in `config.moon`


## app `environment`s
### `development`

use this to test while developing, the app will know and handle debug stuff.
if `enable_console` is enabled in `config.moon` (which it is by default), you're able to access the lapis console (https://github.com/leafo/lapis-console) via `/_lazuli/console`

### `test`

use this to test for production, the app will think it's in production, but the server uses test/development config

### `production`

use this when running for production

## using lazuli as a git submodule

the lua/moon paths are set to prefer "./" over the lazuli project root, so just copy the `*.moon` files you want to change from lazuli's root into your project root.
but make sure you run `setup.zsh` from inside the lazuli root each time you update the project, and watch for changes made in the lazuli project (e.g. new config vars, etc)
