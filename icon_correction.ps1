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