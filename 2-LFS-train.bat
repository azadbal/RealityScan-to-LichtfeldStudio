@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ============================================================
REM LichtFeld Studio – CLI Splat Training
REM Input  : ./LichtfieldStudio_Input   (next to this .bat)
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
for /f "usebackq tokens=1* delims==" %%A in ("%SETTINGS_FILE%") do (
  if not "%%A"=="" if not "%%A:~0,1%"=="#" if not "%%A:~0,1%"==";" (
    call set "%%A=%%B"
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

REM ----- Optional toggles -----
set "OPTIONAL_FLAGS="
if /I "%ENABLE_BILATERAL_GRID%"=="1" set "OPTIONAL_FLAGS=%OPTIONAL_FLAGS% --bilateral-grid"
if /I "%ENABLE_MIP_MAP%"=="1" set "OPTIONAL_FLAGS=%OPTIONAL_FLAGS% --mip-map"
if /I "%ENABLE_HEADLESS%"=="1" set "OPTIONAL_FLAGS=%OPTIONAL_FLAGS% --headless"

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
  --iter %ITER% ^
  --strategy %STRATEGY% ^
  --sh-degree %SH_DEGREE% ^
  --resize_factor %RESIZE% ^
  --tile-mode %TILE_MODE% ^
  --max-width %MAX_WIDTH% ^
  --log-level %LOG_LEVEL% ^
  %OPTIONAL_FLAGS% ^
  %EXTRA_FLAGS%

endlocal
