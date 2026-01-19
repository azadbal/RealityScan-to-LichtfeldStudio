@echo on
setlocal ENABLEDELAYEDEXPANSION

set "ROOT=%~dp0"

echo [MASTER] Running step 1
call "%ROOT%1-RS-alignment-localCoordinate.bat" autoquit

echo [MASTER] Running step 2
call "%ROOT%2-LFS-train.bat"

echo [MASTER] Done running all steps (no error checks).
endlocal
exit /b 0
