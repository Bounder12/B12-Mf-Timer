#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Point1X = 0
Point1Y = 0
Point2X = 0
Point2Y = 0
Pixel1 = 0
Pixel2 = 0
IniPath = %A_WorkingDir%\B12 MF Timer.ini

SetTimer,WatchMouse,50
WatchMouse:
MouseGetPos,X,Y
PixelGetColor, P, X, Y
ActiveWindow =% WinExist("A")
ToolTip,`n`n`n`n`nX:%X% Y:%Y%`nColor: %P%`nX1:%Point1X% Y1:%Point1Y%`nColor1: %Pixel1%`nX2:%Point2X% Y2:%Point2Y%`nColor3: %Pixel2%`nActiveWindow: %ActiveWindow%

Return

^1::
{
Point1X :=X
Point1Y :=Y
Pixel1 :=P
IniWrite, %P%, %IniPath%, Check1, Color1
IniWrite, %X%, %IniPath%, Check1, X1
IniWrite, %Y%, %IniPath%, Check1, Y1
IniWrite, %ActiveWindow%, %IniPath%, Check3, ActiveWindow
Return
}

^2::
{
Point2X :=X
Point2Y :=Y
Pixel2 :=P
IniWrite, %P%, %IniPath%, Check2, Color3
IniWrite, %X%, %IniPath%, Check2, X2
IniWrite, %Y%, %IniPath%, Check2, Y2
IniWrite, %ActiveWindow%, %IniPath%, Check3, ActiveWindow
Return
}

^x::
ExitApp