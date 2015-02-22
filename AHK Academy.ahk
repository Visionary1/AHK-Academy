; File encoding:  UTF-8
;@Ahk2Exe-SetName         AHK Academy x86
;@Ahk2Exe-SetDescription  AHK Academy x86
;@Ahk2Exe-SetVersion 0.1
;@Ahk2Exe-SetCopyright    ahkscript.org Soft
;@Ahk2Exe-SetCompanyName  ahkscript.org Soft
;@Ahk2Exe-SetOrigFilename AHK Academy x86
#Include <CustomFont> ;use font without installation
#Include DeHashBang.ahk ; DeHashBang
#Include EM_SetCueBanner.ahk ;Creat Lecture Edit style
#Include ExecScript.ahk ; ExecScript.ahk

#SingleInstance force
#NoTrayIcon
SetBatchLines, -1

Title = AHK Academy x86
pVersion := "0.1 beta"
DefaultDesc =
DefaultName = %A_UserName%

Shell := ComObjCreate("WScript.Shell")
FileEncoding, UTF-8
CustomFont.Add(A_Temp . "\coding.ttf")

;////////////////////////// Main gui
Gui, Main:New, +Resize +LastFound -DPIScale 
Menu, LoadMenu, Add, &Start Lecture, MenuLectureStart
Menu, LoadMenu, Add, &Lecture HTML file, MenuLoadLecture
Menu, LoadMenu, Add, &ahk code file, MenuLoadAHK
Menu, WriteMenu, Add, &Lecture with example code, MenuWriteFullLecture
Menu, WriteMenu, Add, &Only Lecture, MenuWriteOnlyLecture
Menu, MyMenuBar, Add, &Load, :LoadMenu
Menu, MyMenuBar, Add, &Write Lecture, :WriteMenu
Menu, MyMenuBar, Add, &AutoHotkey Help File, MenuHelpFile
Menu, MyMenuBar, Add, &About, Aboutthis
Gui, Menu, MyMenuBar
Gui, Add, ActiveX, x0 y0 w345 h480 vWB hwndATLWinHWND, Shell.Explorer
WB.silent := true
Gui, Margin, 5, 5
Gui, Color,, 232C31
Gui, Font, s18 cF5F5F5, 나눔고딕코딩
Gui, Add, Edit, vCodeEditor WantTab -Wrap HScroll t14 r2
Gui, Font, s10, Segoe UI
Gui, Add, Button, gRunButton vRun hwndRunbt, &Test Code
Gui, Add, Button, gResetButton vReset, &Reset Code
Gui, Add, Button, gNextButton v_Next, &Next Lecture
Gui, Show, % "w" (A_ScreenWidth-500) " h" (A_ScreenHeight-350), %Title%
; ///////////////////////// Lecture Gui
Gui, Lecture: new, -DPIScale
Gui, Lecture: Margin, 5, 5
Gui, Lecture: Font, s15, Segoe UI
Gui, Lecture: Add, Edit, w911 vL_Author hwndCL_Author,
EM_SetCueBanner(CL_Author, "Author")
Gui, Lecture: Add, Edit, w911 vL_Title hwndCL_Title,
EM_SetCueBanner(CL_Title, "Lecture Title, this is will be the name of a lecture file")
Gui, Lecture: Add, Edit, w911 h400 vL_Article WantTab , Article
Gui, Lecture: Add, Edit, w911 vL_AddL hwndCL_al,
EM_SetCueBanner(CL_al, "Lecture additional link & download link (optional)")
Gui, Lecture: Add, Button, w911 vL_Create, Write
Gui, Lecture: Show, AutoSize Hide, Create Lecture
return

; //////////////////////////////////////////// Menu Part
MenuLectureStart:
GuiControlGet, CodeEditor
Gui, +OwnDialogs
if CodeEditor
{
	MsgBox, 4132, %Title%, Overwrite code?
	IfMsgBox, No
		return
}
FilePath := A_ScriptDir . "\En\1 .AHK Academy.html"
FileOpen(FilePath, "r").Read()
WB.Navigate(FilePath)
StringReplace, ExampleScript, FilePath, .html, .ahk
IfExist, %ExampleScript%
	GuiControl,, CodeEditor, % FileOpen(ExampleScript, "r").Read()
return

MenuLoadLecture:
GuiControlGet, CodeEditor
Gui, +OwnDialogs
FileSelectFile, FilePath, 3, , Open a Lecture, HTML file (*.html)
if ErrorLevel
	return
FileOpen(FilePath, "r").Read()
WB.Navigate(FilePath)
StringReplace, ExampleScript, FilePath, .html, .ahk
IfExist, %ExampleScript%
{
	if CodeEditor
	{
		MsgBox, 4132, %Title%, Overwrite code?
		IfMsgBox, No
			return
	}
	GuiControl,, CodeEditor, % FileOpen(ExampleScript, "r").Read()
}
return

MenuLoadAHK:
GuiControlGet, CodeEditor
Gui, +OwnDialogs
FileSelectFile, FilePath, 3, , Open a code file, ahk file (*.ahk)
if ErrorLevel
	return
FileOpen(FilePath, "r").Read()
if CodeEditor
{
	MsgBox, 4132, %Title%, Overwrite code?
	IfMsgBox, No
		return
}
GuiControl,, CodeEditor, % FileOpen(FilePath, "r").Read()
return

MenuWriteFullLecture:
MsgBox, 4160, %Title%, Under developement
return

MenuWriteOnlyLecture:
Gui, Lecture: Show
return

MenuHelpFile:
try
	Run, %A_Temp%\AutoHotkey.chm
return

AboutThis:
Gui, +OwnDialogs
MsgBox, 4160, %Title%, 
(
%Title% v%pVersion%
Embedded AutoHotkey : AutoHotkey_H Unicode 32-bit v1.1.19.3

Thanks to & Reference
Lexikos for developing AutoHotkey
HotKetIt's AutoHotkey_H
GeekDude's CodeQuickTester
joedf's HTML and CSS gui tutorial

and all ahkscript.org users
)
return

; ////////////////////////////// Only Lecture Part

LectureGuiClose:
Gui, Lecture: Hide
return

LectureButtonWrite:
Gui, Lecture: Submit, NoHide
MsgBox, % L_Article
MyLecture =
( 
<!DOCTYPE html>
<html>
    <head>
        <style>
            body{font-family:sans-serif;background-color:#F5F5F5;}
            #title{font-size:30px;}
            #corner{font-size:12px;position:absolute;top:8px;right:8px;}
        </style>
    </head>
    <body>
        <div id="title">%L_Title%</div>
        <div id="corner">By %L_Author%</div>
        <br>%L_Article%</br>
        <p id="footer">
            <a href="%L_AddL%">Additional Link</a>
        </p>
    </body>
</html>
)
IfNotExist, %L_Article%.html
{
	FileAppend, %MyLecture%, %L_Title%.html
	if ErrorLevel = 0
		MsgBox, 4160, Lecture Created!, Lecture %L_Title% created!
	else
		MsgBox, % ErrorLevel
}
else
	MsgBox, 4112, oh, Lecture %L_Title% aleady exists
return

;//////////////////////////////////// Main Gui Part

MainGuiSize:
GuiControl, Move, CodeEditor, % "x" 350 "y" 0 "w" A_GuiWidth-10 "h" A_GuiHeight-32
ButtonWidth := (A_GuiWidth/5)
GuiControl, Move, Run, % "x" 355 "y" A_GuiHeight-27 "w" ButtonWidth "h" 22
GuiControl, Move, Reset, % "x" A_GuiWidth-(A_GuiWidth/4) "y" A_GuiHeight-27 "w" ButtonWidth "h" 22
GuiControl, Move, _Next, % "x" A_GuiWidth-(A_GuiWidth/2 -45) "y" A_GuiHeight-27 "w" ButtonWidth "h" 22
WinMove, %   "ahk_id " . ATLWinHWND, , 5,0, 345, (A_GuiHeight+5)
return

NextButton:
Gui, +OwnDialogs
if FilePath
{
	MsgBox, 4132, %Title%, Start next lecture?
	IfMsgBox, Yes
	{
		Loop, Parse, FilePath, \
		{
			IfInString, A_LoopField, .html
			{
				StringLeft, Lecture_number, A_LoopField, 2
				StringReplace, _newL, A_LoopField, %Lecture_number%, % Lecture_number + 1 " "
				StringReplace, FilePath, FilePath, %A_LoopField%, %_newL%
				IfExist, %FilePath%
				{
					WB.Navigate(FilePath)
					StringReplace, ExampleScript, FilePath, .html, .ahk
					GuiControl,, CodeEditor, % FileOpen(ExampleScript, "r").Read()
				}
				else
					MsgBox, 4112, %Title%, No more series lecture!
			}
		}
	}
}
return

MainGuiDropFiles:
Gui, +OwnDialogs
GuiControlGet, CodeEditor
if CodeEditor
{
	MsgBox, 4132, %Title%, Overwrite code?
	IfMsgBox, No
		return
}
GuiControl,, CodeEditor, % FileOpen(StrSplit(A_GuiEvent, "`n")[1], "r").Read()
return

RunButton:
if (Exec.Status == 0) ; Running
	Exec.Terminate() ; CheckIfRunning updates the GUI
else ; Not running or doesn't exist
{
	GuiControlGet, CodeEditor, Main:
	Exec := ExecScript(CodeEditor, Params, DeHashBang(CodeEditor))
	GuiControl, Main:, Run, &Terminate Code
	SetTimer, CheckIfRunning, 100
}
return

ResetButton:                              ; Reset Button
Gui, +OwnDialogs
GuiControlGet, CodeEditor
if CodeEditor
{
	MsgBox, 4132, %Title%, Reset the code?
	IfMsgBox, Yes
	{
		CodeEditor := ""
		GuiControl,, CodeEditor, ;
	}
}
return

#If Exec.Status == 0
Escape::Exec.Terminate() ; CheckIfRunning updates the GUI
#If

GuiEscape:
MainGuiClose:
Gui, +OwnDialogs
GuiControlGet, CodeEditor
if !CodeEditor
	ExitApp
MsgBox, 4132, %Title%, Exit Program?
IfMsgBox, Yes
{
	try
		CustomFont.Remove()
	ExitApp
}
return

CheckIfRunning:
if (Exec.Status == 1)
{
	SetTimer, CheckIfRunning, Off
	GuiControl, Main:, Run, &Test Code
}
return
