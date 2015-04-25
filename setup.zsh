#!/bin/zsh

export LAZULI_PATH="$(readlink -f $(dirname $0))"
export LAZULI_REAL_ROOT="$LAZULI_PATH/.root"
export LAZULI_SRC="$LAZULI_PATH/.src"
export LAZULI_ROOT="/tmp/.lazuli.$(uuidgen -t)-$(uuidgen -r)"

continue_stage=n
if [ -f "$LAZULI_PATH/.continue_stage" ]
  then continue_stage=$(cat "$LAZULI_PATH/.continue_stage")
fi

if [ -f "$LAZULI_PATH/.continue_root" ]
  then LAZULI_ROOT=$(cat "$LAZULI_PATH/.continue_root")
fi

case $continue_stage in
  n)
    rm -f "$LAZULI_PATH/.continue_stage"
    rm -rf "$LAZULI_ROOT" "$LAZULI_SRC" "$LAZULI_REAL_ROOT"
    mkdir -p "$LAZULI_REAL_ROOT" "$LAZULI_SRC"
    ln -s "$LAZULI_REAL_ROOT" "$LAZULI_ROOT"
    echo "$LAZULI_ROOT" > "$LAZULI_PATH/.continue_root"
    ;&
  luajit)
    echo "luajit" > "$LAZULI_PATH/.continue_stage"
    cd $LAZULI_SRC
    git clone http://luajit.org/git/luajit-2.0.git luajit || exit
    cd luajit
    git checkout v2.1
    git pull
    make amalg PREFIX=$LAZULI_ROOT CPATH=$LAZULI_ROOT/include LIBRARY_PATH=$LAZULI_ROOT/lib && \
    make install PREFIX=$LAZULI_ROOT || exit
    ln -sf luajit-2.1.0-alpha $LAZULI_ROOT/bin/luajit
    ;&
  luarocks)
    echo "luarocks" > "$LAZULI_PATH/.continue_stage"
    cd $LAZULI_SRC
    git clone git://github.com/keplerproject/luarocks.git || exit
    cd luarocks
    ./configure --prefix=$LAZULI_ROOT \
                --lua-version=5.1 \
                --lua-suffix=jit \
                --with-lua=$LAZULI_ROOT \
                --with-lua-include=$LAZULI_ROOT/include/luajit-2.1 \
                --with-lua-lib=$LAZULI_ROOT/lib/lua/5.1 \
                --force-config && \
    make build && make install || exit
    ;&
  msgpack)
    echo "msgpack" > "$LAZULI_PATH/.continue_stage"
    # messagepack
    $LAZULI_ROOT/bin/luarocks install lua-messagepack || exit
    ;&
  moonscript)
    echo "moonscript" > "$LAZULI_PATH/.continue_stage"
    $LAZULI_ROOT/bin/luarocks install moonscript
    ;&
  openresty)
    echo "openresty" > "$LAZULI_PATH/.continue_stage"
    cd $LAZULI_SRC
    wget http://openresty.org/download/ngx_openresty-1.7.10.1.tar.gz -O ngx_openresty-1.7.10.1.tar.gz
    tar xzvf ngx_openresty-1.7.10.1.tar.gz
    cd ngx_openresty-1.7.10.1
    ./configure --prefix=$LAZULI_ROOT --with-luajit=$LAZULI_ROOT --with-pcre-jit --with-ipv6 && \
    make && \
    make install || exit
    ;&
  lapis)
    echo "lapis" > "$LAZULI_PATH/.continue_stage"
    $LAZULI_ROOT/bin/luarocks install lapis
    ;&
  wrappers)
    echo "wrappers" > "$LAZULI_PATH/.continue_stage"
    # wrappers
    cat > $LAZULI_PATH/.run <<END
#!/bin/zsh
export LAZULI_PATH="\$(readlink -f \$(dirname \$0))"
export LAZULI_REAL_ROOT="\$LAZULI_PATH/.root"
export LAZULI_ROOT="$LAZULI_ROOT"

[ -e "\$LAZULI_ROOT" ] || ln -s "\$LAZULI_PATH/.root" \$LAZULI_ROOT

export PATH="\$LAZULI_ROOT/bin:\$PATH"
export LUA_PATH="\$LAZULI_PATH/custom_?.lua;\$LAZULI_PATH/src/?/init.lua;\$LAZULI_PATH/src/?.lua;\$LAZULI_PATH/?.lua;\$LUA_PATH;\$LAZULI_ROOT/share/luajit-2.1.0-alpha/?.lua;\$LAZULI_ROOT/share/lua/5.1/?.lua;\$LAZULI_ROOT/share/lua/5.1/?/init.lua"
export MOON_PATH="\$LAZULI_PATH/custom_?.moon;\$LAZULI_PATH/src/?/init.moon;\$LAZULI_PATH/src/?.moon;\$LAZULI_PATH/?.moon;\$MOON_PATH;\$LAZULI_ROOT/share/luajit-2.1.0-alpha/?.moon;\$LAZULI_ROOT/share/lua/5.1/?.moon;\$LAZULI_ROOT/share/lua/5.1/?/init.moon"
export LD_LIBRARY_PATH="\$LAZULI_ROOT/lib:\$LD_LIBRARY_PATH"

fn=\$(basename \$0)
if [ "\$fn" = ".run" ]
  then exec "\$@"
else
  exec \$fn "\$@"
fi
END
    chmod a+rx $LAZULI_PATH/.run
    ln -sf .run $LAZULI_PATH/lapis
    ln -sf .run $LAZULI_PATH/moonc
    ln -sf .run $LAZULI_PATH/luarocks
    ;&
esac

# cleanup
rm -rf "$LAZULI_SRC"
rm -f "$LAZULI_ROOT" "$LAZULI_PATH/.continue_stage" "$LAZULI_PATH/.continue_root"
