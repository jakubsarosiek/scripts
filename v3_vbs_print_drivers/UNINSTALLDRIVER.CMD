@echo off
set srcdir=%~dp0
cd %srcdir%
cscript.exe /nologo "%srcdir%\uninstall.vbs"
rem cscript.exe /nologo "%srcdir%\prnport.vbs" -d -r OD1
rem cscript.exe /nologo "%srcdir%\prnport.vbs" -d -r OD2
