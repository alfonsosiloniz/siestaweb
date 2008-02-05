@echo off
xcopy /s bin\*class sbin\
C:\jdk1.5.0_09\bin\jar cvfm AgenteGigaset.jar MANIFEST.MF  -C sbin .
