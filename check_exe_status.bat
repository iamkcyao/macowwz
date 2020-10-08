@echo off
tasklist|findstr ^%1 >/NUL 2>&1
if %errorlevel% == 0 (
echo "1"
) else (
echo "0"
)
