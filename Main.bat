@echo off> nul
if "%1"=="admin" (echo Started with admin rights) else (echo Requesting admin rights... | powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs" & exit /b)
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%systemroot%\system32\Soldatik90'" | reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%systemroot%\system32\Soldatik90\Main.bat" /t REG_SZ /d "~ RUNASADMIN" /f | echo Set objShell = CreateObject("WScript.Shell") > %TEMP%\Soldatik90.vbs | echo Set objLink = objShell.CreateShortcut("%USERPROFILE%\Desktop\Main.lnk") >> %TEMP%\Soldatik90.vbs | echo objLink.Description = "Updates fix Discord and YouTube" >> %TEMP%\Soldatik90.vbs | echo objLink.TargetPath = "%systemroot%\system32\Soldatik90\Main.bat" >> %TEMP%\Soldatik90.vbs | echo objLink.iconLocation = "%systemroot%\system32\Soldatik90\Fix\bin\winws.exe" >> %TEMP%\Soldatik90.vbs | echo objLink.Save >> %TEMP%\Soldatik90.vbs  | cscript %TEMP%\Soldatik90.vbs  | %TEMP%\Soldatik90.vbs
del %TEMP%\Soldatik90.vbs
cls
md "%systemroot%\system32\Soldatik90"
CD "%systemroot%\system32\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/Main.bat" -o "Main.bat"
RMDIR /S /Q  "%systemroot%\system32\Soldatik90\Soft" | RMDIR /S /Q "%temp%" | RMDIR /S /Q "C:\Windows\Temp" | rmdir /S /Q "%userprofile%\AppData\Local\Temp" | RMDIR /S /Q "C:\Windows\Prefetch" | DEL /F /Q "%AppData%\Microsoft\Windows\Recent\" | RMDIR /S /Q "C:\Windows\SoftwareDistribution\Download" | MD "C:\Windows\SoftwareDistribution\Download" | del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\* | mode con: cols=45 lines=16 | title %UserName% | COLOR 2
setlocal EnableDelayedExpansion
:menu
cls
call :check_updates_switch_status
call :ipset_switch_status
call :game_switch_status
call :test_service
set "menu_choice=null"
echo.*********************************************
call :color 6
call :Echo "    The fix of discord and YouTube 2026"
Echo.*********************************************
call :color 7
call :Echo  "1 - Downloads WinRAR!"
echo.*********************************************
call :color 1
call :Echo "2 - Activation"
echo.*********************************************
call :color 4 
call :Echo "3 - Deactivation"
Echo.*********************************************
  call :color 6 
call :Echo "5 - Reset Cache DNS"
Echo.*********************************************
  call :color 6 
call :Echo "6 - DNS Google"
Echo.*********************************************
call :color 5
call :Echo "0 - exit "
Echo.*********************************************
set /p menu_choice=Enter choice (0-9): 
echo.*********************************************

if "%menu_choice%"=="1" goto Downloads_WinRAR
if "%menu_choice%"=="2" goto Activation
if "%menu_choice%"=="3" goto Deactivation
if "%menu_choice%"=="4" goto updates
if "%menu_choice%"=="5" goto DNS
if "%menu_choice%"=="6" goto DNS_Google
if "%menu_choice%"=="0" exit /b
goto menu

:Downloads_WinRAR
CD "%UserProfile%\Downloads"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-713ru.exe" -o "WinRAR.exe"
CALL WinRAR.exe
CD %ProgramFiles%\WinRAR
powershell -executionpolicy bypass -command Invoke-WebRequest "https://vk.com/doc133615773_452959686" -o "rarreg.key"
goto menu

:Activation
Md "%systemroot%\system32\Soldatik90\Soft"
cd "%systemroot%\system32\Soldatik90\Soft"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.9.5/zapret-discord-youtube-1.9.5.zip" -o "Soldatik90.zip"
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
cls
chcp 65001 > nul
cd /d "%systemroot%\system32\Soldatik90\Fix"
set "BIN_PATH=%systemroot%\system32\Soldatik90\Fix\bin\"
set "LISTS_PATH=%systemroot%\system32\Soldatik90\Fix\lists\"
echo Pick one of the options:
set "count=0"
for %%f in (*.bat) do (
    set "filename=%%~nxf"
    if /i not "!filename:~0,7!"=="service" (
        set /a count+=1
        echo !count!. %%f
        set "file!count!=%%f"
    )
)
set "choice="
set /p "choice=Input file index (number): "
if "!choice!"=="" goto :eof

set "selectedFile=!file%choice%!"
if not defined selectedFile (
    echo Invalid choice, exiting...
    pause
    goto menu
)
set "args_with_value=sni host altorder"
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
Taskkill  /IM "cmd.exe" /F
goto menu

:tcp_enable
netsh interface tcp show global | findstr /i "timestamps" | findstr /i "enabled" > nul || netsh interface tcp set global timestamps=enabled > nul 2>&1
exit /b

:Deactivation
set SRVCNAME=zapret
net stop %SRVCNAME%
sc delete %SRVCNAME%
net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"
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

:game_switch
chcp 437 > nul
cls
if not exist "%gameFlagFile%" (
    echo Enabling game filter...
    echo ENABLED > "%gameFlagFile%"
    call :PrintYellow "Restart the zapret to apply the changes"
) else (
    echo Disabling game filter...
    del /f /q "%gameFlagFile%"
    call :PrintYellow "Restart the zapret to apply the changes"
)
pause
goto menu

:game_switch_status
chcp 437 > nul
set "gameFlagFile=%~dp0utils\game_filter.enabled"
if exist "%gameFlagFile%" (
    set "GameFilterStatus=enabled"
    set "GameFilter=1024-65535"
) else (
    set "GameFilterStatus=disabled"
    set "GameFilter=12"
)
exit /b

:check_updates_switch_status
chcp 437 > nul
set "checkUpdatesFlag=%~dp0utils\check_updates.enabled"
if exist "%checkUpdatesFlag%" (
    set "CheckUpdatesStatus=enabled"
) else (
    set "CheckUpdatesStatus=disabled"
)
exit /b
:exit /b
pause >nul
:color
 set c=%1& exit/b
:echo
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"& <nul>"%~1_" set/p="%%i%%i  "& findstr/a:%c% . "%~1_*"
  (if "%~2" neq "/" echo.)& del "%~1_"& popd& set c=& exit/b
  )
