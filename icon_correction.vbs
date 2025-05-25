Set objShell = CreateObject("WScript.Shell")
powershellCommand = "powershell -ExecutionPolicy Bypass -File ""D:\icon_correction\icon_correction.ps1"""
objShell.Run powershellCommand, 0, False
