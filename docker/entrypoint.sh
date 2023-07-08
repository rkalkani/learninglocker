#!/bin/bash

set -eu

# use envsubst to update nginx config with environment variables
envsubst "\$XAPI_SERVER \$API_PORT \$UI_PORT" </etc/nginx/conf.d/default.template >/etc/nginx/sites-enabled/default

# Proceed with the actual app, itself
exec $@
