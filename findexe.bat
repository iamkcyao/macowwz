@echo off
setlocal enabledelayedexpansion
set /a n=0
set /a n1=0
for %%i in (%*) do (set /a n+=1)
@echo {"data":[
for %%a in (%*) do (
set /a n1+=1
@echo {"{#SERVERNAME}":"%%a"
if !n1! neq !n! (
@echo },
) else (
@echo }
)
)
echo ]}
