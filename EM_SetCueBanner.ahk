EM_SetCueBanner(hWnd, Cue)
{
	static EM_SETCUEBANNER := 0x1501
	return DllCall("User32.dll\SendMessage", "Ptr", hWnd, "UInt", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}
