#!/bin/sh

find $1 -type d -exec chown mars:mars {} \;
find $1 -type f -exec chown mars:mars {} \;
