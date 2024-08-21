 
#!/bin/bash

gst-launch-1.0 -v v4l2src device=/dev/video0 ! "image/jpeg,width=1280, height=720, framerate=30/1" ! rtpjpegpay ! udpsink host=127.0.0.1 port=5600
