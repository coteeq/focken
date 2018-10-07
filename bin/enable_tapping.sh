#!/bin/sh
xinput set-prop `xinput list | grep Synaptics | sed -r 's/([^0-9]*([0-9]*)){2}.*/\2/'` `xinput list-props \`xinput list | grep Synaptics | sed -r 's/([^0-9]*([0-9]*)){2}.*/\2/'\` | grep "Tapping Enabled" | head -1 | sed -r 's/([^0-9]*([0-9]*)){1}.*/\2/'` 1

