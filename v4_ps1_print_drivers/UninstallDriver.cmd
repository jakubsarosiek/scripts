@echo off
set srcdir=%~dp0
cd %srcdir%
powershell.exe -file "%srcdir%\uninstall.ps1"
