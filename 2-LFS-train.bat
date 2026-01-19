@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ============================================================
REM LichtFeld Studio – CLI Splat Training
REM Input  : ./colmap   (next to this .bat)
REM Output : ./LichtfieldStudio_Output  (auto-created)
REM ============================================================

REM ----- Resolve BAT directory (no trailing slash) -----
set "BAT_DIR=%~dp0"
if "%BAT_DIR:~-1%"=="\" set "BAT_DIR=%BAT_DIR:~0,-1%"
set "SCRIPT_DIR=%BAT_DIR%"
for %%A in ("%SCRIPT_DIR%\..") do set "ROOT=%%~fA"
for %%A in ("%ROOT%") do set "ROOT_NAME=%%~nA"

set "SETTINGS_FILE=%SCRIPT_DIR%\User_Settings.txt"
if not exist "%SETTINGS_FILE%" (
  echo ERROR: Missing User_Settings.txt
  exit /b 1
)
for /f "usebackq delims=" %%L in ("%SETTINGS_FILE%") do (
  set "LINE=%%L"
  if not "!LINE!"=="" if not "!LINE:~0,1!"=="#" if not "!LINE:~0,1!"==";" (
    if "!LINE!"=="!LINE:=!" (
      call set "%%L=1"
    ) else (
      for /f "tokens=1* delims==" %%A in ("!LINE!") do (
        call set "%%A=%%B"
      )
    )
  )
)

REM ----- Paths -----
set "INPUT_DIR=%LFS_INPUT_DIR%"
set "OUTPUT_DIR=%LFS_OUTPUT_DIR%"

REM ----- Path to LichtFeld Studio executable -----
set "LFS_EXE=%LFS_EXE%"

REM ----- User-set training parameters -----
set "ITER=%ITER%"
set "STRATEGY=%STRATEGY%"
set "SH_DEGREE=%SH_DEGREE%"
set "RESIZE=%RESIZE%"
set "TILE_MODE=%TILE_MODE%"
set "MAX_WIDTH=%MAX_WIDTH%"
set "LOG_LEVEL=%LOG_LEVEL%"
set "RESIZE_ARG="
if /i "%RESIZE%"=="auto" set "RESIZE_ARG=--resize_factor=auto"
if /i not "%RESIZE%"=="auto" if not "%RESIZE%"=="" set "RESIZE_ARG=--resize_factor=%RESIZE%"

REM ----- Optional flags -----
set "BILATERAL_GRID=%BILATERAL_GRID%"
set "ENABLE_MIP=%ENABLE_MIP%"
set "HEADLESS=%HEADLESS%"

set "OPTIONAL_FLAGS="
if "%BILATERAL_GRID%"=="1" set "OPTIONAL_FLAGS=%OPTIONAL_FLAGS% --bilateral-grid"
if "%ENABLE_MIP%"=="1" set "OPTIONAL_FLAGS=%OPTIONAL_FLAGS% --enable-mip"
if "%HEADLESS%"=="1" set "OPTIONAL_FLAGS=%OPTIONAL_FLAGS% --headless"

REM ----- Extra flags (edit freely) -----
set "EXTRA_FLAGS=%EXTRA_FLAGS%"

REM ============================================================
REM Safety checks
REM ============================================================

if not exist "%LFS_EXE%" (
  echo ERROR: LichtFeld-Studio.exe not found:
  echo %LFS_EXE%
  exit /b 1
)

if not exist "%INPUT_DIR%" (
  echo ERROR: Input folder not found:
  echo %INPUT_DIR%
  exit /b 1
)

REM ============================================================
REM Create output folder if missing
REM ============================================================

if not exist "%OUTPUT_DIR%" (
  mkdir "%OUTPUT_DIR%"
)

REM ============================================================
REM Run training
REM ============================================================

"%LFS_EXE%" ^
  --data-path "%INPUT_DIR%" ^
  --output-path "%OUTPUT_DIR%" ^
  --train ^
  %OPTIONAL_FLAGS% ^
  --iter %ITER% ^
  --strategy=%STRATEGY% ^
  --sh-degree=%SH_DEGREE% ^
  %RESIZE_ARG% ^
  --tile-mode=%TILE_MODE% ^
  --max-width=%MAX_WIDTH% ^
  --log-level=%LOG_LEVEL% ^
  %EXTRA_FLAGS%

endlocal
