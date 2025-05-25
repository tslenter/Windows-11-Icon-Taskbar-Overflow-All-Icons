
# Windows 11 Icon Taskbar Overflow All Icons
Fix for the overflow Windows 11 Taskbar Icons (Displays all icons)
```
icon_correction.ps1 is the script that checks the values and correct sets the correct flag for the icon.
icon_correction.vbs is the VBS which allows you to run the check silent without a pop-up screen.
The vbs script has it location default to D:\icon_correction\icon_correction.ps1. Correct this if you like a different path.
```

# Automate in Windows 11 
```
To automate this make a schedule job and run this every 5 minutes.
```

## icon_correction.ps1 contains:
```
$RegistryPath = 'HKCU:\Control Panel\NotifyIconSettings'
$Name = 'IsPromoted'
$DesiredValue = 1
$Debug = 0

Get-ChildItem -Path $RegistryPath -Recurse | ForEach-Object {
    $currentItem = $_.PSPath

    # Check if the property exists
    $existingProperty = Get-ItemProperty -Path $currentItem -Name $Name -ErrorAction SilentlyContinue

    if (0 -eq (Get-ItemProperty -Path $currentItem -Name $Name).$Name) {
		if ($Debug -eq 1) {
			Write-Output "[$currentItem] '$Name' not found. Creating with value $DesiredValue..."
		}
        New-ItemProperty -Path $currentItem -Name $Name -Value $DesiredValue -PropertyType DWORD -Force | Out-Null
    } else {
		if ($Debug -eq 1) {
			$currentValue = (Get-ItemProperty -Path $currentItem -Name $Name).$Name
			Write-Output "[$currentItem] '$Name' already exists with value: $currentValue"
		}
    }
}
```
## icon_correction.vbs contains:
```
Set objShell = CreateObject("WScript.Shell")
powershellCommand = "powershell -ExecutionPolicy Bypass -File ""D:\icon_correction\icon_correction.ps1"""
objShell.Run powershellCommand, 0, False
```
