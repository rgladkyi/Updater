@echo off

rem "%CMDEX_ROOT_DIR%\Interfaces\cmdex_update.bat"
set UPDATER_PATH=%1
set UPDATER_NAME=%~n1

call copy %UPDATER_PATH% "%TEMP%\%UPDATER_NAME%"
(call rt.bat "%TEMP%\%UPDATER_NAME%") && goto :EOF


