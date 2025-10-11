#!/bin/bash

PATH=/home/$USER/.config/
COPY=/usr/bin/cp
## Copying the files from .config
echo $PATH
$COPY -r $PATH/sway .
$COPY -r $PATH/waybar .
$COPY -r $PATH/kitty .
$COPY -r $PATH/nvim .


