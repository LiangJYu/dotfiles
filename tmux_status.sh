#!/bin/sh
tmux new-session \; \
    split-window -v -p 75 \; \
    send-keys 'htop' C-m \; \
    split-window -v -p 67 \; \
    send-keys 'nvtop' C-m \; \
    split-window -v -p 50 \; \
    send-keys 'sudo i7z' C-m \;
