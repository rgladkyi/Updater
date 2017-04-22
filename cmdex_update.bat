@echo off

:Start
set CURRENT_DIRECTORY_TO_COME_BACK=%cd%
goto CheckForUpdate

rem "https://rgladkyi.github.io/CMDEX/Release/VersionId.txt"
set WEB_FILE_VERSION_ID=%1

rem "C:\CMDEX\Release\VersionIdUpdated.txt"
set LOCAL_FILE_VERSION_ID=%2
set LOCAL_FILE_VERSION_ID_EXT_NAME=%~x2
set LOCAL_FILE_VERSION_ID_NEW=%LOCAL_FILE_VERSION_ID%.updated.%LOCAL_FILE_VERSION_ID_EXT_NAME%

rem "https://rgladkyi.github.io/CMDEX/Release/CMDEXfolder.zip"
set WEB_ZIP_UPDATE=%3

rem "C:\CMDEX\Release\CMDEXfolder_new.zip"
set LOCAL_ZIP_UPDATE=%4
set LOCAL_ZIP_UPDATE_EXT_NAME=%~x4
set LOCAL_ZIP_UPDATE_NEW=%LOCAL_ZIP_UPDATE%.updated.%LOCAL_ZIP_UPDATE_EXT_NAME%
set LOCAL_ZIP_UPDATE_PREV=%LOCAL_ZIP_UPDATE%.previous.%LOCAL_ZIP_UPDATE_EXT_NAME%

set FOLDER_TO_UPDATE=%5

:CheckForUpdate
call wget -q --user-agent="Chrome" --no-check-certificate %WEB_FILE_VERSION_ID% -O %LOCAL_FILE_VERSION_ID_NEW% 1> NUL 2> NUL
if %errorlevel% neq 0 (echo Download fails. Check itself the 'updatex.bat' in 'Interfaces' folder. && goto End)

set /p VersionId_txt=<%LOCAL_FILE_VERSION_ID%
set /p VersionIdUpdated_txt=<%LOCAL_FILE_VERSION_ID_NEW%

echo.
echo Current version: %VersionId_txt%
echo New version: %VersionIdUpdated_txt%
echo.

if %VersionIdUpdated_txt% gtr %VersionId_txt% (goto UpdateCMDEXByZip) else (echo You are using the latest version. && echo. && echo.)
goto End

:UpdateCMDEXByInstaller
call wget --user-agent="Chrome" --no-check-certificate "https://rgladkyi.github.io/CMDEX/Release/CMDEXsetup.exe" -O "C:\CMDEX\Release\CMDEXsetup_new.exe"
if %errorlevel% neq 0 (echo Download fails. Check itself the 'updatex.bat' in 'Interfaces' folder. && goto End)

call del "C:\CMDEX\Release\CMDEXsetup_prev.exe"
call mv "C:\CMDEX\Release\CMDEXsetup.exe" "C:\CMDEX\Release\CMDEXsetup_prev.exe"
call mv "C:\CMDEX\Release\CMDEXsetup_new.exe" "C:\CMDEX\Release\CMDEXsetup.exe"

echo.
echo Warning: Files of "C:\CMDEX" will be overwritten.
echo Note: In case of updating, Reboot after installation is not required and can be skipped.
echo.

call pause

call "C:\CMDEX\Release\CMDEXsetup.exe"

echo Check whether installation is OK..
goto End

:UpdateCMDEXByZip
call wget --user-agent="Chrome" --no-check-certificate %WEB_ZIP_UPDATE% -O %LOCAL_ZIP_UPDATE_NEW%
if %errorlevel% neq 0 (echo Download fails. Check itself the 'updatex.bat' in 'Interfaces' folder. && goto End)

call del %LOCAL_ZIP_UPDATE_PREV%
call mv %LOCAL_ZIP_UPDATE% %LOCAL_ZIP_UPDATE_PREV%
call mv %LOCAL_ZIP_UPDATE_NEW% %LOCAL_ZIP_UPDATE%

echo.
echo Warning: Files of "C:\CMDEX" will be overwritten.
echo.

call pause

set CD_TO_GO_BACK_update=%cd%

cd /d %FOLDER_TO_UPDATE%
cd ..

echo Updating...
md "%TEMP%\7z"

call xcopy /e /y /q "C:\CMDEX\Tools\7z" "%TEMP%\7z"
rem set '-o' paraeter
call "%TEMP%\7z\7za.exe" x -aoa %LOCAL_ZIP_UPDATE%

call rmdir /s /q "%TEMP%\7z" 

echo Note: May exist errors related to overwring,
echo and it's OK if no need to overwrite it's.

cd /d %CD_TO_GO_BACK_update%
goto End

:End
call cd /d %CURRENT_DIRECTORY_TO_COME_BACK%
goto Exit

:Exit

rem echo Deleting temporary copy.
rem echo.
rem call del "%TEMP%\cmdex_update_temp.bat"


