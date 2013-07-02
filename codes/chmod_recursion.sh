#!/bin/sh
find /home/mars/Share -type d -exec chmod 755 {} \;
find /home/mars/Share -type f -exec chmod 644 {} \;
chmod 777 /home/mars/Share
