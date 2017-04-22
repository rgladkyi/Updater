@echo off

echo To execute in: "%cd%"
echo Planned to execute: %*

rem call sudo.lnk /c run_externally "%cd%" %*
call sudo.lnk /c %*

call pause


