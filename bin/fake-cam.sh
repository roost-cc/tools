#!/bin/sh
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="Fake Cam" exclusive_caps=1
ffmpeg -loop 1 -re -i 1080-portrait.jpg -f v4l2 -vcodec rawvideo -pix_fmt yuv420p /dev/video10
sudo rmmod v4l2loopback
