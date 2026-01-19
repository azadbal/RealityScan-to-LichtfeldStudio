:: Import images and align into RealityScan, save project with folder-based ProjectName
:: Export image poses (Registeration) and sfm point cloud for Lichtfield Studio

@echo on
setlocal enabledelayedexpansion

set "QUIT_FLAG="
if /I "%~1"=="autoquit" set "QUIT_FLAG=-quit"


:: root folder of this script
set "RootFolder=%~dp0"
set "SCRIPT_DIR=%RootFolder:~0,-1%"
for %%A in ("%SCRIPT_DIR%\..") do set "ROOT=%%~fA"
for %%i in ("%ROOT%") do set "ProjectName=%%~nxi"
set "ROOT_NAME=%ProjectName%"

set "SETTINGS_FILE=%SCRIPT_DIR%\User_Settings.txt"
if not exist "%SETTINGS_FILE%" (
  echo [ERROR] Missing User_Settings.txt
  exit /b 1
)
for /f "usebackq tokens=1* delims==" %%A in ("%SETTINGS_FILE%") do (
  if not "%%A"=="" if not "%%A:~0,1%"=="#" if not "%%A:~0,1%"==";" (
    call set "%%A=%%B"
  )
)

set "ProjectName=%PROJECT_NAME%"
set "RealityCaptureExe=%REALITYSCAN_EXE%"

:: define RC output folder and create it if missing
set "RSFolder=%RS_DIR%"
if not exist "%RSFolder%" mkdir "%RSFolder%"

:: define RC output folder and create it if missing
set "LFSFolder=%LFS_INPUT_DIR%"
if not exist "%LFSFolder%" mkdir "%LFSFolder%"

:: set paths
set "Images=%IMAGE_DIR%"
set "SettingsFolder=%SETTINGS_DIR%"
set "Project=%RSFolder%\%ProjectName%.rsproj"

:: run RealityCapture
"%RealityCaptureExe%" -newScene ^
    -set "appIncSubdirs=true" ^
    -addFolder "%Images%" ^
	-selectAllImages ^
	-setConstantCalibrationGroups ^
    -align ^
	-save "%Project%" ^
    -selectMaximalComponent ^
	-selectAllImages ^
	-exportRegistration "%LFSFolder%\reg.csv" "%SettingsFolder%\colmap-rs-exportsettings.xml" ^
	%QUIT_FLAG%
	
