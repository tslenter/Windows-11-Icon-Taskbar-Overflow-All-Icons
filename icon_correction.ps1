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