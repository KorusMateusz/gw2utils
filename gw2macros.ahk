#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; jump dodge
#If WinActive("Guild Wars 2")
#NoEnv
+Space::
SendInput, {Space Down}
SendInput, {V Down}
sleep 5
SendInput, {Space Up}
SendInput, {V Up}
Return

; use first item in inventory on bottom right of the screen
#If WinActive("Guild Wars 2")
#NoEnv
End::
MouseGetPos, xpos, ypos
Sysget, totalWidth, 78
Sysget, totalHeight, 79
width := totalWidth - 120
height := totalHeight - 40

Click %width%, %height%, 2

Click %xpos%, %ypos%, 0
Return
