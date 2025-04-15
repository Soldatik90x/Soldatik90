@echo off
chcp 866 > nul
mode con: cols=45 lines=15 | title %UserName% | COLOR 2
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B ) 
echo Set objShell = CreateObject("WScript.Shell") > %TEMP%\CreateShortcut.vbs | echo Set objLink = objShell.CreateShortcut("%USERPROFILE%\Desktop\YouTube.lnk") >> %TEMP%\CreateShortcut.vbs | echo objLink.Description = "Updates fix Discord and YouTube" >> %TEMP%\CreateShortcut.vbs | echo objLink.TargetPath = "%ProgramFiles%\Windows Security\Soldatik90\YouTube.BAT" >> %TEMP%\CreateShortcut.vbs | echo objLink.iconLocation = "%ProgramFiles%\Windows Security\Soldatik90\Program\bin\winws.exe" >> %TEMP%\CreateShortcut.vbs | echo objLink.Save >> %TEMP%\CreateShortcut.vbs  | cscript %TEMP%\CreateShortcut.vbs
del %TEMP%\CreateShortcut.vbs | powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Windows Security\Soldatik90'" | reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%ProgramFiles%\Windows Security\Soldatik90\YouTube.BAT" /t REG_SZ /d "~ RUNASADMIN" /f 
:m1
Echo Select a program:
echo.*********************************************
call :color 6
call :Echo "    The fix of discord and YouTube 2025"
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
call :color 5
call :Echo "4 - Updates fix Discord and YouTube v1.7.0"
Echo.*********************************************  
Set /p choice="Your choice: "
if not defined choice goto m1
if "%choice%"=="1" (start 
CD %UserProfile%\Downloads
powershell -executionpolicy bypass -command Invoke-WebRequest "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701ru.exe" -o "WinRAR.exe"
CALL WinRAR.exe
MD %ProgramFiles%\WinRAR
CD %ProgramFiles%\WinRAR
powershell -executionpolicy bypass -command Invoke-WebRequest "https://vk.com/doc133615773_452959686" -o "rarreg.key"
Taskkill  /IM "cmd.exe" /F
)
if "%choice%"=="2" (start
Taskkill  /IM "goodbyedpi.exe" /F
Taskkill  /IM "winws.exe" /F
sc stop "GoodbyeDPI"
sc delete "GoodbyeDPI"
sc stop "WinDivert1.4"
sc delete "WinDivert1.4"
set SRVCNAME=zapret
net stop %SRVCNAME%
sc delete %SRVCNAME%
net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"
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
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\Program"
netsh interface ip set dns name="Ethernet" source="static" address="8.8.8.8"
netsh interface ip add dns name="Ethernet" address="8.8.4.4" index=2
md "%ProgramFiles%\Windows Security\Soldatik90\discord"
cd "%ProgramFiles%\Windows Security\Soldatik90\discord"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.7.0/zapret-discord-youtube-1.7.0.rar" -o "discord.zip"
"%ProgramFiles%\WinRAR\winrar.exe" x -ibck "%ProgramFiles%\Windows Security\Soldatik90\discord\discord.zip" *.* "%ProgramFiles%\Windows Security\Soldatik90\discord"
"%ProgramFiles%\7-Zip\7z.exe" x  "%ProgramFiles%\Windows Security\Soldatik90\discord\discord.zip" -o"%ProgramFiles%\Windows Security\Soldatik90\discord" -r -y
del /F /Q "discord.zip"
echo @echo off >> "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt"
echo mode con: cols=45 lines=3 >> "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt"
echo title %UserName% >> "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt"
echo COLOR 2 >> "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt"
type "%ProgramFiles%\Windows Security\Soldatik90\discord\service_install.bat" >> "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt"
type "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt" > "%ProgramFiles%\Windows Security\Soldatik90\discord\service_install.bat"
del "%ProgramFiles%\Windows Security\Soldatik90\discord\newFile.txt"
ECHO. >>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO animakima.online>>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO rutube.ru>>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO doramru.org>>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO flcksbr.top>>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO vk.com>>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO. >>"%ProgramFiles%\Windows Security\Soldatik90\discord\list-general.txt"
ECHO RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\discord" >> "%ProgramFiles%\Windows Security\Soldatik90\discord\service_install.bat"
ECHO Taskkill  /IM "cmd.exe" /F>>"%ProgramFiles%\Windows Security\Soldatik90\discord\service_install.bat"
MD "%ProgramFiles%\Windows Security\Soldatik90\Program\bin"
MD "%ProgramFiles%\Windows Security\Soldatik90\Program\lists"
COPY "%ProgramFiles%\Windows Security\Soldatik90\discord\bin" "%ProgramFiles%\Windows Security\Soldatik90\Program\bin"
COPY "%ProgramFiles%\Windows Security\Soldatik90\discord\lists" "%ProgramFiles%\Windows Security\Soldatik90\Program\lists"
COPY "%ProgramFiles%\Windows Security\Soldatik90\discord\discord.bat"  "%ProgramFiles%\Windows Security\Soldatik90\Program\discord.bat"
COPY "%ProgramFiles%\Windows Security\Soldatik90\discord\service_remove.bat"  "%ProgramFiles%\Windows Security\Soldatik90\Program\service_remove.bat"
COPY "%ProgramFiles%\Windows Security\Soldatik90\discord\general.bat"  "%ProgramFiles%\Windows Security\Soldatik90\Program\general.bat"
COPY "%ProgramFiles%\Windows Security\Soldatik90\discord\service_install.bat"  "%ProgramFiles%\Windows Security\Soldatik90\Program\service_install.bat"
CALL "%ProgramFiles%\Windows Security\Soldatik90\Program\service_install.bat"
)
if "%choice%"=="3" (start 
Taskkill  /IM "goodbyedpi.exe" /F
Taskkill  /IM "winws.exe" /F
Taskkill  /IM "WinRAR.exe" /F
sc stop "GoodbyeDPI"
sc delete "GoodbyeDPI"
sc stop "WinDivert1.4"
sc delete "WinDivert1.4"
set SRVCNAME=zapret
net stop %SRVCNAME%
sc delete %SRVCNAME%
net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"
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
netsh interface ip set dns name="Ethernet" source="static" address=""
netsh interface ip add dns name="Ethernet" address="" index=2
ipconfig /flushdns
call %ProgramFiles%\Windows Security\Soldatik90\discord\service_remove.bat
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\discord"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\YouTube"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\Program"
Taskkill  /IM "cmd.exe" /F
)
if "%choice%"=="4" (start
MD "%ProgramFiles%\Windows Security\Soldatik90"
cd "%ProgramFiles%\Windows Security\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/YouTube.bat" -o "YouTube.BAT"
CALL "%ProgramFiles%\Windows Security\Soldatik90\YouTube.BAT"
)
Echo.
Echo The choice of the task was not made correctly
Echo.
Echo.
goto m1
pause >nul
pause
:color
 set c=%1& exit/b
:echo
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"& <nul>"%~1_" set/p="%%i%%i  "& findstr/a:%c% . "%~1_*"
  (if "%~2" neq "/" echo.)& del "%~1_"& popd& set c=& exit/b
  )
