#!/bin/bash

gst-launch-1.0 udpsrc  port=5600 ! application/x-rtp,encoding-name=JPEG,payload=26 ! rtpjpegdepay ! jpegdec ! autovideosink
