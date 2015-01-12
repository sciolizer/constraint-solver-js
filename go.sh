#!/usr/bin/env sh

set -ev

lsc -bc -o lib src
lsc -bc -o lib/examples src/examples
lsc -bc -o lib-test test
lsc -bc -o lib-test/examples test/examples
#mocha --require LiveScript --colors --reporter spec --compilers ls:node_modules/LiveScript
mocha --colors --reporter spec lib-test
#mocha --colors --reporter spec lib-test/examples
#mocha --colors --reporter spec lib-test/constraints
