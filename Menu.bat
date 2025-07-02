@echo off> nul
if "%1"=="admin" (echo Started with admin rights) else (echo Requesting admin rights... | powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs" & exit /b)
DEL /S /Q "C:\Users\%username%\Desktop\Menu.LNK" | powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%ProgramFiles%\Windows Security\Soldatik90'" | reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%ProgramFiles%\Windows Security\Soldatik90\Menu.bat" /t REG_SZ /d "~ RUNASADMIN" /f | echo Set objShell = CreateObject("WScript.Shell") > %TEMP%\CreateShortcut.vbs | echo Set objLink = objShell.CreateShortcut("%USERPROFILE%\Desktop\Menu.lnk") >> %TEMP%\CreateShortcut.vbs | echo objLink.Description = "Updates fix Discord and YouTube" >> %TEMP%\CreateShortcut.vbs | echo objLink.TargetPath = "%ProgramFiles%\Windows Security\Soldatik90\Menu.bat" >> %TEMP%\CreateShortcut.vbs | echo objLink.iconLocation = "%ProgramFiles%\Windows Security\Soldatik90\ico.ico" >> %TEMP%\CreateShortcut.vbs | echo objLink.Save >> %TEMP%\CreateShortcut.vbs  | cscript %TEMP%\CreateShortcut.vbs
attrib -h "%ProgramFiles%\Windows Security\Soldatik90\sol.ico" | del %TEMP%\CreateShortcut.vbs | RMDIR /S /Q "%ProgramFiles%\Windows Security\Soldatik90\ico.ico"
mode con: cols=45 lines=15 | title %UserName% | COLOR 2
RMDIR /S /Q  "%ProgramFiles%\Windows Security\Soldatik90\Soft"
CD "%ProgramFiles%\Windows Security\Soldatik90"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/Menu.bat" -o "Menu.bat"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://raw.githubusercontent.com/Soldatik90x/Soldatik90/refs/heads/main/ico.ico" -o "ico.ico"
attrib +h "%ProgramFiles%\Windows Security\Soldatik90\ico.ico"
setlocal EnableDelayedExpansion
:menu
cls
set "menu_choice=null"
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
call :Echo "4 - Updates fix Discord and YouTube "
Echo.********************************************* 
call :color 5
call :Echo "0 - exit "
Echo.*********************************************
set /p menu_choice=Enter choice (0-5): 
echo.*********************************************

if "%menu_choice%"=="1" goto Downloads_WinRAR
if "%menu_choice%"=="2" goto Activation
if "%menu_choice%"=="3" goto Deactivation
if "%menu_choice%"=="4" goto updates
if "%menu_choice%"=="0" exit /b
goto menu
:Downloads_WinRAR

CD "%UserProfile%\Downloads"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-711ru.exe" -o "WinRAR.exe"
CALL WinRAR.exe
CD %ProgramFiles%\WinRAR
powershell -executionpolicy bypass -command Invoke-WebRequest "https://vk.com/doc133615773_452959686" -o "rarreg.key"
goto menu
:Activation

netsh interface ip set dns name="Ethernet" source="static" address="8.8.8.8"
netsh interface ip add dns name="Ethernet" address="8.8.4.4" index=2
ECHO animakima.site>>"%ProgramFiles%\Windows Security\Soldatik90\Fix\lists\list-general.txt"
ECHO googleusercontent.com>>"%ProgramFiles%\Windows Security\Soldatik90\Fix\lists\list-general.txt"
del /S /Q "C:\Users\%username%\Downloads\Menu.bat" | del /S /Q "C:\Users\%username%\Desktop\Menu.bat"
cd /d "%ProgramFiles%\Windows Security\Soldatik90\Fix"
set "BIN_PATH=%ProgramFiles%\Windows Security\Soldatik90\Fix\bin\"
set "LISTS_PATH=%ProgramFiles%\Windows Security\Soldatik90\Fix\lists\"

:: Searching for .bat files in current folder, except files that start with "service"
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
Taskkill  /IM "cmd.exe" /F
goto menu
:Deactivation

netsh interface ip set dns name="Ethernet" source="static" address=""
netsh interface ip add dns name="Ethernet" address="" index=2
cls
chcp 65001 > nul

set SRVCNAME=zapret
net stop %SRVCNAME%
sc delete %SRVCNAME%

net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"
RMDIR /S /Q  "%ProgramFiles%\Windows Security\Soldatik90\Fix"
RMDIR /S /Q  "%ProgramFiles%\Windows Security\Soldatik90\Zapret"
Taskkill  /IM "cmd.exe" /F
goto menu
:updates

Md "%ProgramFiles%\Windows Security\Soldatik90\Soft"
cd "%ProgramFiles%\Windows Security\Soldatik90\Soft"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.7.2b/zapret-discord-youtube-1.7.2b.zip" -o "Soldatik90.zip"
powershell.exe -Nop -Nol -Command "Expand-Archive './Soldatik90.zip' './'
cd "%ProgramFiles%\Windows Security\Soldatik90\Soft\bin"
powershell -executionpolicy bypass -command Invoke-WebRequest "https://github.com/Soldatik90x/Soldatik90/raw/refs/heads/main/WinWS.exe" -o "WinWS.exe"
del /F /Q "Soldatik90.zip"
MD "%ProgramFiles%\Windows Security\Soldatik90\Fix"
MD "%ProgramFiles%\Windows Security\Soldatik90\Fix\bin"
MD "%ProgramFiles%\Windows Security\Soldatik90\Fix\lists"
COPY "%ProgramFiles%\Windows Security\Soldatik90\Soft\bin" "%ProgramFiles%\Windows Security\Soldatik90\Fix\bin"
COPY "%ProgramFiles%\Windows Security\Soldatik90\Soft\lists" "%ProgramFiles%\Windows Security\Soldatik90\Fix\lists"
COPY "%ProgramFiles%\Windows Security\Soldatik90\soft\general (ALT2).bat" "%ProgramFiles%\Windows Security\Soldatik90\Fix\general.bat"
RMDIR /S /Q  "%ProgramFiles%\Windows Security\Soldatik90\Soft"
goto menu
:exit /b
pause >nul
:color
 set c=%1& exit/b
:echo
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"& <nul>"%~1_" set/p="%%i%%i  "& findstr/a:%c% . "%~1_*"
  (if "%~2" neq "/" echo.)& del "%~1_"& popd& set c=& exit/b
  )
