@echo off
REM This script schedules a task to run once at the next reboot

REM Define the task name
set TASK_NAME="RunBSInstallerOnce"

if "%1" == "launch" (
	schtasks /delete /tn %TASK_NAME% /f
	call "C:\Windows\Temp\BSInstaller_Renamed.exe" -force
) else (
	ren "C:\Windows\Temp\BSInstaller.exe" BSInstaller_Renamed.exe
	
	REM Schedule the task to run at the next boot
	schtasks /create /tn %TASK_NAME% /tr ""%0" launch" /sc onstart /ru SYSTEM /f

	REM Display a confirmation message
	echo The task %TASK_NAME% has been scheduled to run once at the next reboot.
)

