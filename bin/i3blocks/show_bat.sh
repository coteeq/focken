#!/bin/sh
if [[ ! -z "$(acpi | grep Charging)" ]]
then
    printf '<span color="#00F080">%s</span>' "$(acpi | grep -Po '[0-9]*%')"
elif [[ ! -z "$(acpi | grep Full)" ]]
then
    printf '<span color="#00F000">FULL</span>'
elif [[ ! -z "$(acpi | grep Unknown)" ]]
then
    printf '<span color="#00F080">%s</span>' "$(acpi | grep -Po '[0-9]*%')"
else
    printf '<span color="#00D0F0">%s</span>' "$(acpi | grep -Po '[0-9]*%')"
fi

