#!/usr/bin/env python3

import re
import sys
import urllib.parse

sd_url = sys.argv[1]

# https://stackoverflow.com/a/3873422
for m in re.finditer('https', sd_url):
    strip_start = m.start()
print(strip_start)

index = 0
while index < len(sd_url):
    index = sd_url.find('https', index)
    if index == -1:
        break
    print('https found at', index)
    index += 2
print(urllib.parse.unquote(sd_url[strip_start:]))
