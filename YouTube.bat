@echo off
chcp 866 > nul
mode con: cols=45 lines=11 | title %UserName% | COLOR 2
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B ) 
mklink "%userprofile%\Desktop\%~nx0" "%~f0"
:m1
Echo �롥�� �ணࠬ��:
echo.*********************************************
call :color 7
call :Echo  "           1 - Downloads WinRAR!"
echo.*********************************************
call :color 1
call :Echo "      2 - Fix Discord YouTube � ���ᨨ!"
echo.*********************************************
call :color 4
call :Echo "   3 - Deactivation Fix Discord YouTube"
Echo.*********************************************
call :color 6
call :Echo "           4 - ��⨢��� WIN 10-11"
Echo.*********************************************
Set /p choice="��� �롮�: "
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
netsh interface ip set dns name="Ethernet" source="static" address="8.8.8.8"
netsh interface ip add dns name="Ethernet" address="8.8.4.4" index=2
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\discord"
md "%ProgramFiles%\Windows Security\Soldatik90\discord"
cd "%ProgramFiles%\Windows Security\Soldatik90\discord"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.5.1/zapret-discord-youtube-1.5.1.rar" -o "discord.zip"
"%ProgramFiles%\WinRAR\winrar.exe" x -ibck "%ProgramFiles%\Windows Security\Soldatik90\discord\discord.zip" *.* "%ProgramFiles%\Windows Security\Soldatik90\discord"
del /F /Q "discord.zip"
CALL "C:\Program Files\Windows Security\Soldatik90\discord\general.bat"
CALL "C:\Program Files\Windows Security\Soldatik90\discord\service_install.bat"
Taskkill  /IM "cmd.exe" /F
)
if "%choice%"=="3" (start 
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
netsh interface ip set dns name="Ethernet" source="static" address=""
netsh interface ip add dns name="Ethernet" address="" index=2
ipconfig /flushdns
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\discord"
RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\YouTube"
Taskkill  /IM "cmd.exe" /F
)
if "%choice%"=="4" (start 
slui.exe /upk
slmgr /xpr
changepk.exe /productkey VK7JG-NPHTM-C97JM-9MPGT-3V66T
)
Echo.
Echo �� �ࠢ��쭮 ᤥ��� �롮� �������
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