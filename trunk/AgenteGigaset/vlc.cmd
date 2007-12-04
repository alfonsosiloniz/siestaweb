"c:\Archivos de programa\VideoLAN\VLC\vlc.exe" %1 --sub-track=0 :sout=#transcode{vcodec=mp2v,soverlay,fps=25,vb=2000,acodec=mpga,ab=192,channels=2}:duplicate{dst=std{access=file,mux=ps,dst=%1.mpg}} --sout-transcode-width=720 --sout-transcode-height=576 --sout-transcode-canvas-aspect=4:3 vlc:quit 
exit
