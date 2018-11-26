#!/bin/python

import subprocess
import os

BAR_OUTPUT = os.environ.get("BAR_OUTPUT")
BLOCK_BUTTON = os.environ.get("BLOCK_BUTTON")
SUBBLOCK = os.environ.get("SUBBLOCK")

def bspc(cmd):
    res = subprocess.run(['bspc'] + cmd.split(' '), stdout=subprocess.PIPE).stdout
    res = res.decode('utf-8')[:-1]
    return res

