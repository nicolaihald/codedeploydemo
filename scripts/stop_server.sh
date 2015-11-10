#!/bin/bash
isExistApp=`pgrep php5-fpm`
if [[ -n  \$isExistApp ]]; then
    service php5-fpm stop
fi
isExistApp=`pgrep nginx`
if [[ -n  \$isExistApp ]]; then
   service nginx stop
fi
