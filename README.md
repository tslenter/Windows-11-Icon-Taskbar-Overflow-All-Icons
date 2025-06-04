
# Windows 11 Icon Taskbar Overflow Display All Icons
Fix for the overflow Windows 11 Taskbar Icons (Displays all icons)
```
icon_correction.ps1 is the script that checks the values and correct sets the correct flag for the icon.
icon_correction.vbs is the VBS which allows you to run the check silent without a pop-up screen.
The vbs script has it location default to D:\icon_correction\icon_correction.ps1. Correct this if you like a different path.
```

# Automate in Windows 11 
```
To automate this make a schedule job and run this every 5 minutes.

To schedule a task in Windows 11, you'll use the Task Scheduler. Open Task Scheduler (search for it in the Start menu), create a new task (either a basic task or a full task), and configure the trigger (when the task runs), action (what the task does), and settings (additional options). 
```

## icon_correction.ps1 contains:
```
$RegistryPath = 'HKCU:\Control Panel\NotifyIconSettings'
$Name = 'IsPromoted'
$DesiredValue = 1
$Debug = 0

Get-ChildItem -Path $RegistryPath -Recurse | ForEach-Object {
    $currentItem = $_.PSPath

    # Try to get the current value of the property, if it exists
    $itemProperty = Get-ItemProperty -Path $currentItem -Name $Name -ErrorAction SilentlyContinue

    if ($null -eq $itemProperty) {
        # Property does not exist, create it
        if ($Debug -eq 1) {
            Write-Output "[$currentItem] '$Name' not found. Creating with value $DesiredValue..."
        }
        New-ItemProperty -Path $currentItem -Name $Name -Value $DesiredValue -PropertyType DWORD -Force | Out-Null
    }
    else {
        $currentValue = $itemProperty.$Name
        if ($currentValue -ne $DesiredValue) {
            # Property exists but is not the desired value — update it
            if ($Debug -eq 1) {
                Write-Output "[$currentItem] '$Name' has value $currentValue. Updating to $DesiredValue..."
            }
            Set-ItemProperty -Path $currentItem -Name $Name -Value $DesiredValue | Out-Null
        }
        elseif ($Debug -eq 1) {
            Write-Output "[$currentItem] '$Name' already has desired value: $DesiredValue"
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
