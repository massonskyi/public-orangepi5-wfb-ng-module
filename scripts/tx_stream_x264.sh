#!/bin/bash

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,framerate=30/1 ! videoscale ! video/x-raw,width=1920,height=1080 ! videoconvert ! x264enc tune=zerolatency bitrate=3500 speed-preset=superfast ! rtph264pay ! udpsink host=127.0.0.1 port=5600
