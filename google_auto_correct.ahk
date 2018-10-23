#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; Ctrl+Alt+c autocorrect selected text
^!j::
clipback := ClipboardAll
clipboard=
Send ^c
ClipWait, 0
UrlDownloadToFile % "https://www.google.com/search?q=" . clipboard, temp
FileRead, contents, temp
FileDelete temp
if (RegExMatch(contents, "(Showing results for|Did you mean:)</span>.*?>(.*?)</a>", match)) {
 StringReplace, clipboard, match2, <b><i>,, All
 StringReplace, clipboard, clipboard, </i></b>,, All
 clipboard := RegExReplace(clipboard, "&#39;", "'")
 clipboard := RegExReplace(clipboard, "&amp;", "&")
}
Send ^v
Sleep 500
clipboard := clipback
return