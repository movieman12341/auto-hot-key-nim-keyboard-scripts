#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Capslock Remapping Script 
; Danik
; danikgames.com
; 
; Functionality:
; - Deactivates capslock for normal (accidental) use.
; - Hold Capslock and drag anywhere in a window to move it (not just the title bar).
; - Access the following functions when pressing Capslock: 
;     Cursor keys           - J, K, L, I
;     Space                 - Enter
;     Home, PgDn, PgUp, End - U, O, Y, H
;     Backspace and Del     - N, M
;     Insert                - B
;     Select all            - A
;     Cut, copy, paste      - S, D, F
;     Close tab, window     - W, E
;     Esc                   - R
;     Next, previous tab    - Tab, Q
;     Undo, redo            - , and .
;  
; To use capslock as you normally would, you can press WinKey + Capslock


; This script is mostly assembled from modified versions of the following awesome scripts:
;
; # Home Row Computing by Gustavo Duarte: http://duartes.org/gustavo/blog/post/home-row-computing for 
; Changes: 
; - Does not need register remapping of AppsKey using SharpKeys.
; - Uses normal cursor key layout 
; - Added more hotkeys for insert, undo, redo etc.
;
; # Get the Linux Alt+Window Drag Functionality in Windows: http://www.howtogeek.com/howto/windows-vista/get-the-linux-altwindow-drag-functionality-in-windows/
; Changes: The only change was using Capslock instead of Alt. This 
; also removes problems in certain applications.




#Persistent
SetCapsLockState, AlwaysOff



; Capslock + jkli (left, down, up, right)

Capslock & h::Send {Blind}{Left DownTemp}
Capslock & h up::Send {Blind}{Left Up}

Capslock & n::Send {Blind}{Down DownTemp}
Capslock & n up::Send {Blind}{Down Up}

Capslock & d::Send {Blind}{Up DownTemp}
Capslock & d up::Send {Blind}{Up Up}

Capslock & t::Send {Blind}{Right DownTemp}
Capslock & t up::Send {Blind}{Right Up}



;my own caps functions top


CapsLock & g::
       if getkeystate("alt") = 0
               Send,^{Left}
       else
               Send,+^{Left}
return

       Capslock & c::                                  ;has to be changed (depending on the keyboard-layout)
               if getkeystate("alt") = 0
                       Send,^{Right}
               else
                       Send,+^{Right}
       return


Capslock & r::
       if getkeystate("alt") = 0
               Send,^{Down}
       else
               Send,+^{Down}
return

CapsLock & f::
       if getkeystate("alt") = 0
               Send,^{Up}
       else
               Send,+^{Up}
return



; Capslock + asdf (select all, cut-copy-paste)

Capslock & a::SendInput {Ctrl Down}{a Down}
Capslock & a up::SendInput {Ctrl Up}{a Up}

Capslock & o::SendInput {Ctrl Down}{x Down}
Capslock & o up::SendInput {Ctrl Up}{x Up}

Capslock & e::SendInput {Ctrl Down}{c Down}
Capslock & e up::SendInput {Ctrl Up}{c Up}

Capslock & u::SendInput {Ctrl Down}{v Down}
Capslock & u up::SendInput {Ctrl Up}{v Up}


; Capslock + wer (close tab or window, press esc)

Capslock & ,::SendInput {Ctrl down}{F4}{Ctrl up}
Capslock & .::SendInput {Alt down}{F4}{Alt up}
Capslock & p::SendInput {Blind}{Esc Down}


; Capslock + nm (insert, backspace, del)

Capslock & x::SendInput {Blind}{Insert Down}
Capslock & m::SendInput {Blind}{Del Down}
Capslock & b::SendInput {Blind}{BS Down}
Capslock & BS::SendInput {Blind}{BS Down}



; Make Capslock & Enter equivalent to Control+Enter
Capslock & Enter::SendInput {Ctrl down}{Enter}{Ctrl up}


; Make Capslock & Alt Equivalent to Control+Alt
!Capslock::SendInput {Ctrl down}{Alt Down}
!Capslock up::SendInput {Ctrl up}{Alt up}


; Capslock + TAB/q (prev/next tab)

Capslock & '::SendInput {Ctrl Down}{Tab Down}
Capslock & ' up::SendInput {Ctrl Up}{Tab Up}
Capslock & Tab::SendInput {Ctrl Down}{Shift Down}{Tab Down}
Capslock & Tab up::SendInput {Ctrl Up}{Shift Up}{Tab Up}

; Capslock + ,/. (undo/redo)

Capslock & w::SendInput {Ctrl Down}{z Down}
Capslock & w up::SendInput {Ctrl Up}{z Up}
Capslock & v::SendInput {Ctrl Down}{y Down}
Capslock & v up::SendInput {Ctrl Up}{y Up}


; Make Capslock+Space -> Enter
Capslock & Space::SendInput {Enter Down}



; Make Win Key + Capslock work like Capslock
+Capslock::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else 
    SetCapsLockState, AlwaysOn
Return





; Drag windows anywhere
;
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; by The How-To Geek
; http://www.howtogeek.com 

Capslock & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return




Capslock & -::SendInput {Blind}{End Down}
Capslock & l::SendInput {Blind}{Home Down}


Capslock & /::SendInput {Blind}{PgUp Down}
Capslock & =::SendInput {Blind}{PgDn Down}










;RecycleBin

#t::

FileRecycleEmpty, C:\
MsgBox, The trash has been taken out.

return






;searchGoogleFromAnyApp

^+j::
{
Send, ^c
Sleep 50
Run, http://www.google.com/search?q=%clipboard%
Return
}


;window is always on top

^SPACE::  Winset, Alwaysontop, , A
