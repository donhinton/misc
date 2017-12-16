#! /usr/bin/env python

import os
import re
import sys

pat = re.compile('.*\.so')
rootDir=sys.argv[1]

for dirName, subdirlist, fileList in os.walk(rootDir):
    for fname in fileList:
        path = os.path.join(dirName, fname)
        if (os.path.islink(path) and not os.path.isdir(path) and not os.path.exists(path) and pat.match(fname)):
            link = os.readlink(path)
            if (link[0] == '/' and not link == '/dev/null'):
                newlink = os.path.join(rootDir, link[1:])
                os.remove(path)
                os.symlink(newlink, path)
