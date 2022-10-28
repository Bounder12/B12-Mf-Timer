#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Variables
Color1 = 
X1 = 
Y1 = 
Color3 = 
X2 = 
Y2 = 
ActiveWindow = 
ActiveWindow1 =
Color2 =
Color4 =
TotalRuntime := 0
GameTime := 0
TotalRuntimeR = 00:00
TotalRuntimeRF = 00:00
GameTimeR = 00:00
GameTimeRF = 00:00
CurrentRun := 1
LastRun = 00:00
Runlist =
RunsSum := 0
Average := 0
AverageF = 00:00
Index := 0
;Inifile Variables
IniPath = %A_WorkingDir%\B12 MF Timer.ini

;Gui setup
Gui, Timer:Add, Text, x2 y2 w195 h20 vTotalRuntimeR, Total Run Time = %TotalRuntimeRF%
Gui, Timer:Add, Text, x2 y22 w195 h20 vGameTimeR, Total Game Time = %GameTimeRF%
Gui, Timer:Add, Text, x2 y42 w195 h20 vAverageF, Average Game Time = %AverageF%
Gui, Timer:Add, Text, x2 y62 w195 h20 vLastRun, Last Game Time = %LastRun%
Gui, Timer:Add, Text, x2 y82 w195 h20, Run List
Gui, Timer:Add, Edit, x2 y102 w195 h100 +Readonly vRunList, %Runlist%
Gui, Timer:Add, Button, x2 y202 w195 h20 gStart, Start
Gui, Timer:Add, Button, x2 y222 w195 h20 gStop, Stop
Gui, Timer:Add, Button, x2 y242 w195 h20 gReset, Reset
Gui, Timer:Add, Button, x2 y262 w195 h20 gExport, Export
Gui, Timer:Add, Button, x2 y282 w195 h20 gGuiClose, Exit
Gui, Timer:-sysmenu
Gui, Timer:+AlwaysOnTop
Gui, Timer:Show, w200 h302

;Initialize Items
if FileExist("B12 MF Timer.ini")
{
IniRead, Color1, %IniPath%, Check1, Color1
IniRead, X1, %IniPath%, Check1, X1
IniRead, Y1, %IniPath%, Check1, Y1
IniRead, Color3, %IniPath%, Check2, Color3
IniRead, X2, %IniPath%, Check2, X2
IniRead, Y2, %IniPath%, Check2, Y2
IniRead, ActiveWindow,%IniPath%, Check3, ActiveWindow
Gosub FormatTimes
Gosub Update
}
Else
{
IniWrite, 00, %IniPath%, Check1, Color1
IniWrite, 00, %IniPath%, Check1, X1
IniWrite, 00, %IniPath%, Check1, Y1
IniWrite, 00, %IniPath%, Check2, Color3
IniWrite, 00, %IniPath%, Check2, X2
IniWrite, 00, %IniPath%, Check2, Y2
IniWrite, 00, %IniPath%, Check3, ActiveWindow
Msgbox, 4096, Warning, Please Use the Configuration tool
Gui, Timer:Destroy
ExitApp
}

Stop:
{
SetTimer, Checking, OFF
SetTimer, Waiting, OFF
Return
}

Start:
{
SetTimer, Checking, 100
Return
}

Reset:
{
Color2 =
Color4 =
TotalRuntime := 0
GameTime := 0
TotalRuntimeR = 00:00
TotalRuntimeRF = 00:00
GameTimeR = 00:00
GameTimeRF = 00:00
CurrentRun := 1
LastRun = 00:00
Runlist =
RunsSum := 0
Average := 0
AverageF = 00:00
Index := 0
Gosub Update
Return
}

Checking:
Gosub CheckWindow
If(Color2 = Color1) and (Color3 = Color4) and (ActiveWindow = ActiveWindow1)
{
	SetTimer, Checking, OFF
	SetTimer, Waiting, 100
}
Gosub UpdateTotalTimer
Gosub UpdateGameTimer
Gosub FormatTimes
Gosub Update
Return

Waiting:
Gosub CheckWindow
If(Color2 != Color1)and (Color3 != Color4) and (ActiveWindow = ActiveWindow1)
{
	Runlist2 = Run %CurrentRun%, %GameTimeRF%`n
	Runlist := Runlist . Runlist2
	CurrentRun := CurrentRun+1
	LastRun = %GameTimeRF%
	RunsSum := RunsSum+GameTimeR
	GameTime = 0
	Index++
	Gosub Average
	SetTimer, Checking, 100
	SetTimer, Waiting, OFF
}
Gosub UpdateTotalTimer
Gosub FormatTimes
Gosub Update
Return

^P::
Pause, Toggle

^1::

Return

Update:
{
Gui, Timer:Tab, 1
GuiControl, Timer:, TotalRuntimeR, Total Run Time = %TotalRuntimeRF%
GuiControl, Timer:, GameTimeR, Total Game Time = %GameTimeRF%
GuiControl, Timer:, RunList, %Runlist%
GuiControl, Timer:, TotalRunTime, Total Run Time = %TotalRuntime%
GuiControl, Timer:, LastRun, Last Game Time = %LastRun%
GuiControl, Timer:, AverageF, Average Game Time = %AverageF%
Return
}

UpdateTotalTimer:
{
TotalRuntime := TotalRuntime+.1
Return
}

UpdateGameTimer:
{
GameTime := GameTime+.1
Return
}

FormatTimes:
{
TotalRuntimeR := Floor(TotalRuntime)
GameTimeR := Floor(GameTime)
TotalRuntimeRF :=% Format("{:02}:{:02}", TotalRuntimeR//60, Mod(TotalRuntimeR, 60))
GameTimeRF :=% Format("{:02}:{:02}", GameTimeR//60, Mod(GameTimeR, 60))
AverageF :=% Format("{:02}:{:02}", Average//60, Mod(Average, 60))
Return
}

Export:
{
Filename = %A_Now%
FileAppend,
(
	%Runlist%
), %A_WorkingDir%\%Filename%.txt
Return
}

CheckWindow:
{
PixelGetColor, Color2, X1, Y1
PixelGetColor, Color4, X2, Y2
ActiveWindow1 =% WinExist("A")
Return
}


Average:
{
Average := Round(RunsSum/Index)
Return
}

; Exit Button label
GuiClose:
Gui, Timer:Destroy
ExitApp
