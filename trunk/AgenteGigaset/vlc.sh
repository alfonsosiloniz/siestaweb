#!/bin/sh
FILE=`echo $1 | sed 's/"//gi'`
vlc ${FILE} --sub-track=0 ":sout=#transcode{vcodec=mp2v,fps=25,soverlay,vb=2000,acodec=mpga,ab=192,channels=2}:duplicate{dst=std{access=file,mux=ps,dst=${FILE}.mpg}}" --sout-transcode-width=720 --sout-transcode-height=576 --sout-transcode-canvas-aspect=4:3 vlc:quit 
