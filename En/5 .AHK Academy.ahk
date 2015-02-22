; Example #1

; Run a program. Note: most programs will require a FULL file path.
Run, %A_ProgramFiles%\Some_Program\Program.exe

; Run a website
Run, http://ahkscript.org

; Example #2
; Several programs do not need a full path, such as Windows-standard programs.
Run, Notepad.exe
Run, MsPaint.exe

; Run the "My Documents" folder using the built-in AHK variable
Run, %A_MyDocuments%

; Run some websites
Run, http://ahkscript.org
Run, http://www.google.com
