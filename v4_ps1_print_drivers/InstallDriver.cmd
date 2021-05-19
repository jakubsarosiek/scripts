@echo off
set srcdir=%~dp0
cd %srcdir%
powershell.exe -file "%srcdir%\install.ps1"
