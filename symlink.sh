#!/bin/sh

TARGET_HOME=$HOME
TARGET_CONFIG=$TARGET_HOME/.config
CUR_DIR=$(pwd)
ln -s $CUR_DIR/bin        $TARGET_HOME/bin
ln -s $CUR_DIR/.tmux.conf $TARGET_HOME/.tmux.conf
ln -s $CUR_DIR/.zprofile  $TARGET_HOME/.zprofile
ln -s $CUR_DIR/.zshrc     $TARGET_HOME/.zshrc

ln -s $CUR_DIR/termite   $TARGET_CONFIG/termite
ln -s $CUR_DIR/alacritty $TARGET_CONFIG/alacritty
ln -s $CUR_DIR/awesome   $TARGET_CONFIG/awesome
ln -s $CUR_DIR/dunst     $TARGET_CONFIG/dunst
ln -s $CUR_DIR/i3        $TARGET_CONFIG/i3
ln -s $CUR_DIR/i3blocks  $TARGET_CONFIG/i3blocks
ln -s $CUR_DIR/i3status  $TARGET_CONFIG/i3status
ln -s $CUR_DIR/kitty     $TARGET_CONFIG/kitty
ln -s $CUR_DIR/nvim      $TARGET_CONFIG/nvim
ln -s $CUR_DIR/ranger    $TARGET_CONFIG/ranger
ln -s $CUR_DIR/rofi      $TARGET_CONFIG/rofi

