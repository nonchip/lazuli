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
the `mk` script builds any moonscript and lesscss (note: you have to install `lessc` if using lesscss) files it finds, while the `lapis` call actually runs the server

### rebuilding/upgrading your app

after you made some changes, you might want to make lapis reload your stuff on the fly:

    ./mk <environment>

### stopping the server

#### in `development` or `test` mode

just press ctrl+c

#### in `production` mode

    ./lapis term

## webserver config
###nginx

    server{
            server_name www.<domain> <domain>;
            location / {
                    proxy_pass   http://127.0.0.1:<port>/;
                    include /etc/nginx/proxy_params;
            }
    }

`<domain>` is the FQDN to handle and `<port>` is the port specified in `config.moon`.
note how you can specify multiple subdomains (no wildcarding by default).

the `/etc/nginx/proxy_params` included should contain at least:

    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

Also, you can speed up things a tiny bit by handling the `/static/` content without proxying. just include something like this below the `location /` block:

    location /static/ {
      alias /PATH/TO/YOUR/LAZULI/APP/static/;
      expires max;
      add_header Pragma public;
      add_header Cache-Control "no-transform,public,max-age=120,s-maxage=300";
    }


###apache2

    <VirtualHost *:80>
            ServerName <domain>
            ProxyPreserveHost On
            ProxyPass / http://127.0.0.1:<port>/
            ProxyPassReverse / http://127.0.0.1:<port>/
    </VirtualHost>

where `<domain>` is the FQDN to handle and `<port>` is the port specified in `config.moon`


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

also make sure you copy the `nginx.conf` and `mime.types` files to your project root, and PLEASE don't call lazuli's subfolder just `./lazuli/`, because this WILL mess up the load order (because of `src/lazuli/init.moon` not being found), just call it `_lazuli` or `lib/lazuli` or something like that
