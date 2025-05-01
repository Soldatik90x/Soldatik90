@echo off
mode con: cols=45 lines=14
title %UserName%
COLOR 2
md "%programFiles%\Windows Security\Soldatik90\Soft"
cd "%programFiles%\Windows Security\Soldatik90\Soft"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/service.bat" -o "service.bat"
echo Set objShell = CreateObject("WScript.Shell") > %TEMP%\CreateShortcut.vbs | echo Set objLink = objShell.CreateShortcut("%USERPROFILE%\Desktop\Soldatik90.lnk") >> %TEMP%\CreateShortcut.vbs | echo objLink.Description = "Updates fix Discord and YouTube" >> %TEMP%\CreateShortcut.vbs | echo objLink.TargetPath = "%ProgramFiles%\Windows Security\Soldatik90\Soft\service.bat" >> %TEMP%\CreateShortcut.vbs | echo objLink.iconLocation = "%ProgramFiles%\Windows Security\Soldatik90\Soft\bin\winws.exe" >> %TEMP%\CreateShortcut.vbs | echo objLink.Save >> %TEMP%\CreateShortcut.vbs  | cscript %TEMP%\CreateShortcut.vbs
del %TEMP%\CreateShortcut.vbs
setlocal EnableDelayedExpansion
set "LOCAL_VERSION=1.7.2"

:: External commands
if "%~1"=="status_zapret" (
    call :test_service zapret soft
    exit /b
)

if "%~1"=="check_updates" (
    call :service_check_updates soft
    exit /b
)

if "%1"=="admin" (
    echo Started with admin rights
) else (
    echo Requesting admin rights...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)


:: MENU ================================
:menu
cls
set "menu_choice=null"
call :color 7
call :Echo "=====================MENU===================="
call :color 6
call :Echo "==================Soldatik90================="
Echo.*********************************************
call :color 7
call :Echo "1. Install Service"
Echo.*********************************************
call :color 1
call :Echo "2. Remove Services"
Echo.*********************************************
call :color 4
call :Echo "5. Check Updates"
Echo.*********************************************
call :color 5
call :Echo "0. Exit"
Echo.*********************************************
set /p menu_choice=Enter choice (0-5): 

if "%menu_choice%"=="1" goto service_install
if "%menu_choice%"=="2" goto service_remove
if "%menu_choice%"=="4" goto service_diagnostics
if "%menu_choice%"=="5" goto service_check_updates
if "%menu_choice%"=="0" exit /b
goto menu



:test_service
set "ServiceName=%~1"
set "ServiceStatus="

for /f "tokens=3 delims=: " %%A in ('sc query "%ServiceName%" ^| findstr /i "STATE"') do set "ServiceStatus=%%A"
set "ServiceStatus=%ServiceStatus: =%"

if "%ServiceStatus%"=="RUNNING" (
    if "%~2"=="soft" (
        echo "%ServiceName%" is ALREADY RUNNING as service, use "service.bat" and choose "Remove Services" first if you want to run standalone bat.
        pause
        exit /b
    ) else (
        echo "%ServiceName%" service is RUNNING.
    )
) else if not "%~2"=="soft" (
    echo "%ServiceName%" is NOT running.
)

exit /b


:: REMOVE ==============================
:service_remove
cls
chcp 65001 > nul

set SRVCNAME=zapret
net stop %SRVCNAME%
sc delete %SRVCNAME%

net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\Soft"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\youtube"
pause
goto menu


:: INSTALL =============================
:service_install
cls
chcp 65001 > nul

:: Main
cd /d "%~dp0"
set "BIN_PATH=%~dp0bin\"
set "LISTS_PATH=%~dp0lists\"

:: Searching for .bat files in current folder, except files that start with "service"
echo Pick one of the options:
set "count=0"
for %%f in (*.bat) do (
    set "filename=%%~nxf"
    if /i not "!filename:~0,7!"=="service" if /i not "!filename:~0,17!"=="cloudflare_switch" (
        set /a count+=1
        echo !count!. %%f
        set "file!count!=%%f"
    )
)

:: Choosing file
set "choice="
set /p "choice=Input file index (number): "
if "!choice!"=="" goto :eof

set "selectedFile=!file%choice%!"
if not defined selectedFile (
    echo Invalid choice, exiting...
    pause
    goto menu
)

:: Args that should be followed by value
set "args_with_value=sni"

:: Parsing args (mergeargs: 2=start param|3=arg with value|1=params args|0=default)
set "args="
set "capture=0"
set "mergeargs=0"
set QUOTE="

for /f "tokens=*" %%a in ('type "!selectedFile!"') do (
    set "line=%%a"

    echo !line! | findstr /i "%BIN%winws.exe" >nul
    if not errorlevel 1 (
        set "capture=1"
    )

    if !capture!==1 (
        if not defined args (
            set "line=!line:*%BIN%winws.exe"=!"
        )

        set "temp_args="
        for %%i in (!line!) do (
            set "arg=%%i"

            if not "!arg!"=="^" (
                if "!arg:~0,2!" EQU "--" if not !mergeargs!==0 (
                    set "mergeargs=0"
                )

                if "!arg:~0,1!" EQU "!QUOTE!" (
                    set "arg=!arg:~1,-1!"

                    echo !arg! | findstr ":" >nul
                    if !errorlevel!==0 (
                        set "arg=\!QUOTE!!arg!\!QUOTE!"
                    ) else if "!arg:~0,1!"=="@" (
                        set "arg=\!QUOTE!@%~dp0!arg:~1!\!QUOTE!"
                    ) else if "!arg:~0,5!"=="%%BIN%%" (
                        set "arg=\!QUOTE!!BIN_PATH!!arg:~5!\!QUOTE!"
                    ) else if "!arg:~0,7!"=="%%LISTS%%" (
                        set "arg=\!QUOTE!!LISTS_PATH!!arg:~7!\!QUOTE!"
                    ) else (
                        set "arg=\!QUOTE!%~dp0!arg!\!QUOTE!"
                    )
                )
                
                if !mergeargs!==1 (
                    set "temp_args=!temp_args!,!arg!"
                ) else if !mergeargs!==3 (
                    set "temp_args=!temp_args!=!arg!"
                    set "mergeargs=1"
                ) else (
                    set "temp_args=!temp_args! !arg!"
                )

                if "!arg:~0,2!" EQU "--" (
                    set "mergeargs=2"
                ) else if !mergeargs!==2 (
                    set "mergeargs=1"
                ) else if !mergeargs!==1 (
                    for %%x in (!args_with_value!) do (
                        if /i "%%x"=="!arg!" (
                            set "mergeargs=3"
                        )
                    )
                )
            )
        )

        if not "!temp_args!"=="" (
            set "args=!args! !temp_args!"
        )
    )
)

:: Creating service with parsed args
set ARGS=%args%
echo Final args: !ARGS!
set SRVCNAME=zapret

net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
sc create %SRVCNAME% binPath= "\"%BIN_PATH%winws.exe\" %ARGS%" DisplayName= "zapret" start= auto
sc description %SRVCNAME% "Zapret DPI bypass software"
sc start %SRVCNAME%

pause
goto menu


:: CHECK UPDATES =======================
:service_check_updates
MD "%ProgramFiles%\Windows Security\Soldatik90\youtube"
CD "%ProgramFiles%\Windows Security\Soldatik90\youtube"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.7.2/zapret-discord-youtube-1.7.2.rar" -o "discord.zip"
"%ProgramFiles%\WinRAR\winrar.exe" x -ibck "%ProgramFiles%\Windows Security\Soldatik90\youtube\discord.zip" *.* "%ProgramFiles%\Windows Security\Soldatik90\youtube"
"%ProgramFiles%\7-Zip\7z.exe" x  "%ProgramFiles%\Windows Security\Soldatik90\youtube\discord.zip" -o"%ProgramFiles%\Windows Security\Soldatik90\youtube" -r -y
MD "%ProgramFiles%\Windows Security\Soldatik90\Soft"
MD "%ProgramFiles%\Windows Security\Soldatik90\Soft\bin"
MD "%ProgramFiles%\Windows Security\Soldatik90\Soft\lists"
copy "%ProgramFiles%\Windows Security\Soldatik90\youtube\bin" "%ProgramFiles%\Windows Security\Soldatik90\Soft\bin"
copy "%ProgramFiles%\Windows Security\Soldatik90\youtube\lists" "%ProgramFiles%\Windows Security\Soldatik90\Soft\lists"
copy "%ProgramFiles%\Windows Security\Soldatik90\youtube\general.bat" "%ProgramFiles%\Windows Security\Soldatik90\Soft\general.bat"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\youtube"
pause
goto menu

:: Utility functions

:PrintGreen
powershell -Command "Write-Host \"%~1\" -ForegroundColor Green"
exit /b

:PrintRed
powershell -Command "Write-Host \"%~1\" -ForegroundColor Red"
exit /b

:PrintYellow
powershell -Command "Write-Host \"%~1\" -ForegroundColor Yellow"
exit /b
:color
 set c=%1& exit/b
:echo
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"& <nul>"%~1_" set/p="%%i%%i  "& findstr/a:%c% . "%~1_*"
  (if "%~2" neq "/" echo.)& del "%~1_"& popd& set c=& exit/b
  )
