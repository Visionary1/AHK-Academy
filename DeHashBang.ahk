DeHashBang(Script)
{
	AhkPath := A_ScriptDir . "\AutoHotkey.exe"
	if RegExMatch(Script, "`a)^\s*`;#!\s*(.+)", Match)
	{
		AhkPath := Trim(Match1)
		Vars := {"%A_ScriptDir%": A_WorkingDir
		, "%A_WorkingDir%": A_WorkingDir
		, "%A_AppData%": A_AppData
		, "%A_AppDataCommon%": A_AppDataCommon
		, "%A_LineFile%": A_ScriptFullPath
		, "%A_AhkPath%": A_AhkPath}
		for SearchText, Replacement in Vars
			StringReplace, AhkPath, AhkPath, %SearchText%, %Replacement%, All
	}
	return AhkPath
}
