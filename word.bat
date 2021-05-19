@echo off

SET VAR1=%1
SET VAR2=%2
SET VAR3=%3
set Server1=10.140.95.101
set Server2=10.140.95.102

REM Sprwadzamy serwer 1
:Server2Unavailable
%SystemRoot%\system32\ping.exe -n 1 %Server1% >nul
if errorlevel 1 (
                goto Server1Unavailable
) else (
                goto Server1Available
)

REM Sprwadzamy serwer 2
:Server1Unavailable
%SystemRoot%\system32\ping.exe -n 1 %Server2% >nul
if errorlevel 1 (
                goto Server2Unavailable
) else (
                goto Server2Available
)

REM Serwer 1 dostępny
:Server1Available
MOVE %VAR2% \\10.140.95.101\c$\XeroxScan\OCR\%VAR3%.docx
MOVE C:\Umango\SCAN\HOTFOLDER\WORD\%VAR3%.xst \\10.140.95.101\c$\XeroxScan\OCR\
goto :EOF

REM Serwer 2 dostępny
:Server2Available
MOVE %VAR2% \\10.140.95.102\c$\XeroxScan\OCR\%VAR3%.docx
MOVE C:\Umango\SCAN\HOTFOLDER\WORD\%VAR3%.xst \\10.140.95.102\c$\XeroxScan\OCR\
goto :EOF