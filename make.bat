@echo off
setlocal

rem ===== Configuration =====
set MINGW_ROOT=C:\Users\ranwa\Documents\work-c\mingw64
set MINGW_VARS=%MINGW_ROOT%\mingwvars.bat
rem =========================

rem Switch to project root (where make.bat is located)
pushd "%~dp0"

rem Initialize MinGW environment only once
if not defined MINGW_ENV_INITIALIZED (
  set MINGW_ENV_INITIALIZED=1
  call "%MINGW_VARS%"
  if errorlevel 1 (
    echo [ERROR] Failed to call %MINGW_VARS%
    popd
    exit /b 1
  )
)

rem Run make
if "%~1"=="" (
  mingw32-make.exe -f "%~dp0makefile"
) else (
  mingw32-make.exe -f "%~dp0makefile" %*
)

set ERR=%ERRORLEVEL%
popd
exit /b %ERR%
