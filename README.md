# lazuli - a lapis framework
## command line
### first time setup

    ./setup.zsh

this installs the dependencies (and some wrappers) locally, thanks to magic I'm not going to explain, just read the source if you want to.

### setting up your app

    ./lapis new

### running your app

    ./moonc .
    ./lapis build <environment>
    ./lapis migrate <environment>
    ./lapis server <environment>

where `<environment>` may be `development` or `production` or any custom defined

### rebuilding/upgrading your app

after you made some changes, you might want to make lapis reload your stuff on the fly:

    ./moonc .
    ./lapis build <environment>
    ./lapis migrate <environment>

### stopping the server

    ./lapis term

