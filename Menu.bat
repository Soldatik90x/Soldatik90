@echo off> nul
if "%1"=="admin" (echo Started with admin rights) else (echo Requesting admin rights... | powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs" & exit /b)
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%systemroot%\system32\Soldatik90'" | reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%systemroot%\system32\Soldatik90\Menu.bat" /t REG_SZ /d "~ RUNASADMIN" /f | echo Set objShell = CreateObject("WScript.Shell") > %TEMP%\Menu.vbs | echo Set objLink = objShell.CreateShortcut("%USERPROFILE%\Desktop\Menu.lnk") >> %TEMP%\Menu.vbs | echo objLink.Description = "Updates fix Discord and YouTube" >> %TEMP%\Menu.vbs | echo objLink.TargetPath = "%systemroot%\system32\Soldatik90\Menu.bat" >> %TEMP%\Soldatik90.vbs | echo objLink.iconLocation = "%systemroot%\system32\Soldatik90\Fix\bin\winws.exe" >> %TEMP%\Menu.vbs | echo objLink.Save >> %TEMP%\Menu.vbs  | cscript %TEMP%\Menu.vbs  | %TEMP%\Menu.vbs
del %TEMP%\Menu.vbs
md "%systemroot%\system32\Soldatik90"
CD "%systemroot%\system32\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/Menu.bat" -o "Menu.bat"
cd "%systemroot%\system32\Soldatik90\Soft\bin"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/WinWS.exe" -o "WinWS.exe"
set "LOCAL_VERSION=1.9.7b"
mode con: cols=55 lines=28 | title %UserName% | COLOR 2
:: External commands
if "%~1"=="status_zapret" (
    call :test_service zapret soft
    call :tcp_enable
    exit /b
)

if "%~1"=="check_updates" (
    if defined NO_UPDATE_CHECK exit /b

    if exist "%~dp0utils\check_updates.enabled" (
        if not "%~2"=="soft" (
            start /b service check_updates soft
        ) else (
            call :service_check_updates soft
        )
    )

    exit /b
)

if "%~1"=="load_game_filter" (
    call :game_switch_status
    exit /b
)

if "%~1"=="load_user_lists" (
    call :load_user_lists
    exit /b
)

if "%1"=="admin" (
    call :check_command chcp
    call :check_command find
    call :check_command findstr
    call :check_command netsh
    
    call :load_user_lists

    echo Started with admin rights
) else (
    call :check_extracted
    call :check_command powershell

    echo Requesting admin rights...
    powershell -NoProfile -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)


:: MENU ================================
setlocal EnableDelayedExpansion
:menu
cls
call :ipset_switch_status
call :game_switch_status
call :check_updates_switch_status

set "menu_choice=null"
cls
chcp 866 > nul
echo.
echo *******************************************************
call :color 6
call :Echo "      The fix of discord and YouTube 2026 v!LOCAL_VERSION!"
echo *******************************************************
echo.
call :color 7
call :Echo "      1. Downloads WinRAR"
call :color 1
call :Echo "      2. Activation"
call :color 4
call :Echo "      3. Deactivation"
call :color 7
call :Echo "      4. Reset Cache DNS"
call :color 1
call :Echo "      5. DNS Google"
call :color 1
call :Echo "      6. Updates"
call :color 6
call :Echo "      0. exit"
echo.
echo *******************************************************
echo.

set /p menu_choice=   Выберите опцию (0-6): 

if "%menu_choice%"=="1" goto Downloads WinRAR
if "%menu_choice%"=="2" goto Activation
if "%menu_choice%"=="3" goto Deactivation
if "%menu_choice%"=="4" goto Reset Cache DNS
if "%menu_choice%"=="5" goto DNS Google
if "%menu_choice%"=="6" goto Updates
if "%menu_choice%"=="0" exit /b
goto menu

:Downloads WinRAR
CD "%UserProfile%\Downloads"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-713ru.exe" -o "WinRAR.exe"
CALL WinRAR.exe
CD %ProgramFiles%\WinRAR
powershell -executionpolicy bypass -command Invoke-WebRequest "https://vk.com/doc133615773_452959686" -o "rarreg.key"
exit /b
goto menu

:Activation
cls
chcp 437 > nul

:: Main
cd /d "%~dp0"
set "BIN_PATH=%~dp0bin\"
set "LISTS_PATH=%~dp0lists\"
cls
chcp 866 > nul
:: Searching for .bat files in current folder, except files that start with "service"
echo Выберите один из вариантов:
set "count=0"
for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem -LiteralPath '.' -Filter '*.bat' | Where-Object { $_.Name -notlike 'service*' } | Sort-Object { [Regex]::Replace($_.Name, '(\d+)', { $args[0].Value.PadLeft(8, '0') }) } | ForEach-Object { $_.Name }"') do (
    set /a count+=1
    echo !count!. %%F
    set "file!count!=%%F"
)

:: Choosing file
set "choice="
set /p "choice=Индекс входного файла (номер: "
if "!choice!"=="" (
    echo The choice is empty, exiting...
    pause
    goto menu
)

set "selectedFile=!file%choice%!"
if not defined selectedFile (
    echo Invalid choice, exiting...
    pause
    goto menu
)

:: Args that should be followed by value
set "args_with_value=sni host altorder"

:: Parsing args (mergeargs: 2=start param|3=arg with value|1=params args|0=default)
set "args="
set "capture=0"
set "mergeargs=0"
set QUOTE="

for /f "tokens=*" %%a in ('type "!selectedFile!"') do (
    set "line=%%a"
    call set "line=%%line:^!=EXCL_MARK%%"

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
                ) else if "!arg:~0,12!" EQU "%%GameFilter%%" (
                    set "arg=%GameFilter%"
                ) else if "!arg:~0,15!" EQU "%%GameFilterTCP%%" (
                    set "arg=%GameFilterTCP%"
                ) else if "!arg:~0,15!" EQU "%%GameFilterUDP%%" (
                    set "arg=%GameFilterUDP%"
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
                ) else if !mergeargs! GEQ 1 (
                    if !mergeargs!==2 set "mergeargs=1"

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
call :tcp_enable

set ARGS=%args%
call set "ARGS=%%ARGS:EXCL_MARK=^!%%"
echo Final args: !ARGS!
set SRVCNAME=zapret

net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
sc create %SRVCNAME% binPath= "\"%BIN_PATH%winws.exe\" !ARGS!" DisplayName= "zapret" start= auto
sc description %SRVCNAME% "Zapret DPI bypass software"
sc start %SRVCNAME%
for %%F in ("!file%choice%!") do (
    set "filename=%%~nF"
)
RMDIR /S /Q "%systemroot%\system32\Soldatik90\Soft"
exit /b
goto menu

:Deactivation
cls
chcp 65001 > nul

set SRVCNAME=zapret
sc query "!SRVCNAME!" >nul 2>&1
if !errorlevel!==0 (
    net stop %SRVCNAME%
    sc delete %SRVCNAME%
) else (
    echo Service "%SRVCNAME%" is not installed.
)

tasklist /FI "IMAGENAME eq winws.exe" | find /I "winws.exe" > nul
if !errorlevel!==0 (
    taskkill /IM winws.exe /F > nul
)

sc query "WinDivert" >nul 2>&1
if !errorlevel!==0 (
    net stop "WinDivert"

    sc query "WinDivert" >nul 2>&1
    if !errorlevel!==0 (
        sc delete "WinDivert"
    )
)
net stop "WinDivert14" >nul 2>&1
sc delete "WinDivert14" >nul 2>&1
RMDIR /S /Q "%systemroot%\system32\Soldatik90\Fix"
RMDIR /S /Q "%systemroot%\system32\Soldatik90\Soft"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90"
goto menu

:DNS
netsh interface ip set dns name="Ethernet" source="static" address=""
netsh interface ip add dns name="Ethernet" address="" index=2
Taskkill  /IM "Discord.exe" /F
rmdir /S /Q %userprofile%\AppData\Roaming\discord\Cache
rmdir /S /Q %userprofile%\AppData\Roaming\discord\Code Cache
rmdir /S /Q %userprofile%\AppData\Roaming\discord\GPUCache
ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew
netsh int ip reset
netsh int ip reset resettcpip.txt
netsh int ipv4 reset reset.log
netsh int ipv6 reset reset.log
netsh winsock reset
netsh winsock reset catalog
shutdown /r /t 0
goto menu

:DNS_Google
netsh interface ip set dns name="Ethernet" source="static" address="8.8.8.8"
netsh interface ip add dns name="Ethernet" address="8.8.4.4" index=2
goto menu

:Updates
Md "%systemroot%\system32\Soldatik90\Soft"
cd "%systemroot%\system32\Soldatik90\Soft"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.9.7b/zapret-discord-youtube-1.9.7b.zip" -o "Soldatik90.zip"
powershell.exe -Nop -Nol -Command "Expand-Archive './Soldatik90.zip' './'
cd "%systemroot%\system32\Soldatik90\Soft\bin"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/WinWS.exe" -o "WinWS.exe"
del /F /Q "Soldatik90.zip"
MD "%systemroot%\system32\Soldatik90\Fix"
MD "%systemroot%\system32\Soldatik90\Fix\bin"
MD "%systemroot%\system32\Soldatik90\Fix\lists"
MD "%systemroot%\system32\Soldatik90\Fix\utils"
COPY "%systemroot%\system32\Soldatik90\Soft\bin" "%systemroot%\system32\Soldatik90\Fix\bin"
COPY "%systemroot%\system32\Soldatik90\Soft\lists" "%systemroot%\system32\Soldatik90\Fix\lists"
COPY "%systemroot%\system32\Soldatik90\Soft\utils" "%systemroot%\system32\Soldatik90\Fix\utils"
COPY "%systemroot%\system32\Soldatik90\soft\general (ALT10).bat" "%systemroot%\system32\Soldatik90\Fix\Soldatik90.bat"
RMDIR /S /Q  "%systemroot%\system32\Soldatik90\Soft" | cls
ECHO googleusercontent.com>>"%systemroot%\system32\Soldatik90\Fix\lists\list-general.txt"
ECHO ubisoft.com>>"%systemroot%\system32\Soldatik90\Fix\lists\list-general.txt"
goto menu

:: LOAD USER LISTS =====================
:load_user_lists
set "LISTS_PATH=%~dp0lists\"

if not exist "%LISTS_PATH%ipset-exclude-user.txt" (
    echo 203.0.113.113/32>"%LISTS_PATH%ipset-exclude-user.txt"
)
if not exist "%LISTS_PATH%list-general-user.txt" (
    echo domain.example.abc>"%LISTS_PATH%list-general-user.txt"
)
if not exist "%LISTS_PATH%list-exclude-user.txt" (
    echo domain.example.abc>"%LISTS_PATH%list-exclude-user.txt"
)

exit /b


:: TCP ENABLE ==========================
:tcp_enable
netsh interface tcp show global | findstr /i "timestamps" | findstr /i "enabled" > nul || netsh interface tcp set global timestamps=enabled > nul 2>&1
exit /b

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
) else if "%ServiceStatus%"=="STOP_PENDING" (
    call :PrintYellow "!ServiceName! is STOP_PENDING, that may be caused by a conflict with another bypass. Run Diagnostics to try to fix conflicts"
) else if not "%~2"=="soft" (
    echo "%ServiceName%" service is NOT running.
)

exit /b
goto menu

:: GAME SWITCH ========================
:game_switch_status
chcp 437 > nul

set "gameFlagFile=%~dp0utils\game_filter.enabled"

if not exist "%gameFlagFile%" (
    set "GameFilterStatus=disabled"
    set "GameFilter=12"
    set "GameFilterTCP=12"
    set "GameFilterUDP=12"
    exit /b
)

set "GameFilterMode="
for /f "usebackq delims=" %%A in ("%gameFlagFile%") do (
    if not defined GameFilterMode set "GameFilterMode=%%A"
)

if /i "%GameFilterMode%"=="all" (
    set "GameFilterStatus=enabled (TCP and UDP)"
    set "GameFilter=1024-65535"
    set "GameFilterTCP=1024-65535"
    set "GameFilterUDP=1024-65535"
) else if /i "%GameFilterMode%"=="tcp" (
    set "GameFilterStatus=enabled (TCP)"
    set "GameFilter=1024-65535"
    set "GameFilterTCP=1024-65535"
    set "GameFilterUDP=12"
) else (
    set "GameFilterStatus=enabled (UDP)"
    set "GameFilter=1024-65535"
    set "GameFilterTCP=12"
    set "GameFilterUDP=1024-65535"
)
exit /b

:check_updates_switch
chcp 437 > nul
cls

if not exist "%checkUpdatesFlag%" (
    echo Enabling check updates...
    echo ENABLED > "%checkUpdatesFlag%"
) else (
    echo Disabling check updates...
    del /f /q "%checkUpdatesFlag%"
)

pause
goto menu


:: IPSET SWITCH =======================
:ipset_switch_status
chcp 437 > nul

set "listFile=%~dp0lists\ipset-all.txt"
for /f %%i in ('type "%listFile%" 2^>nul ^| find /c /v ""') do set "lineCount=%%i"

if !lineCount!==0 (
    set "IPsetStatus=any"
) else (
    findstr /R "^203\.0\.113\.113/32$" "%listFile%" >nul
    if !errorlevel!==0 (
        set "IPsetStatus=none"
    ) else (
        set "IPsetStatus=loaded"
    )
)
exit /b


:ipset_switch
chcp 437 > nul
cls

set "listFile=%~dp0lists\ipset-all.txt"
set "backupFile=%listFile%.backup"

if "%IPsetStatus%"=="loaded" (
    echo Switching to none mode...
    
    if not exist "%backupFile%" (
        ren "%listFile%" "ipset-all.txt.backup"
    ) else (
        del /f /q "%backupFile%"
        ren "%listFile%" "ipset-all.txt.backup"
    )
    
    >"%listFile%" (
        echo 203.0.113.113/32
    )
    
) else if "%IPsetStatus%"=="none" (
    echo Switching to any mode...
    
    >"%listFile%" (
        rem Creating empty file
    )
    
) else if "%IPsetStatus%"=="any" (
    echo Switching to loaded mode...
    
    if exist "%backupFile%" (
        del /f /q "%listFile%"
        ren "%backupFile%" "ipset-all.txt"
    ) else (
        echo Error: no backup to restore. Update list from service menu first
        pause
        goto menu
    )
    
)

pause
goto menu


:: IPSET UPDATE =======================

:: Utility functions

:PrintGreen
powershell -NoProfile -Command "Write-Host \"%~1\" -ForegroundColor Green"
exit /b

:PrintRed
powershell -NoProfile -Command "Write-Host \"%~1\" -ForegroundColor Red"
exit /b

:PrintYellow
powershell -NoProfile -Command "Write-Host \"%~1\" -ForegroundColor Yellow"
exit /b

:check_command
where %1 >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] %1 not found in PATH
    echo Fix your PATH variable with instructions here https://github.com/Flowseal/zapret-discord-youtube/issues/7490
    pause
    exit /b 1
)
exit /b 0

:check_extracted
set "extracted=1"

if not exist "%~dp0bin\" set "extracted=0"

if "%extracted%"=="0" (
    echo Zapret must be extracted from archive first or bin folder not found for some reason
    pause
    exit
)
exit /b 0
:exit /b
pause >nul
:color
 set c=%1& exit/b
:echo
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"& <nul>"%~1_" set/p="%%i%%i  "& findstr/a:%c% . "%~1_*"
  (if "%~2" neq "/" echo.)& del "%~1_"& popd& set c=& exit/b
  )
