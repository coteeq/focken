#!/bin/bash
printf " "
sensors | grep "Core\ [0-9]" | grep -o "\\+[0-9][0-9]\\.[0-9]" | grep -o "[0-9][0-9]" | tr '\r\n' ' ' | sed "s/ $//g" | sed "s/ / - /g"
printf " "

