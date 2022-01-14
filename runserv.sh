#!/bin/sh

set -ue
cd build/web
python3 -m http.server 80
