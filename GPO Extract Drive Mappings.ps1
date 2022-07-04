[xml]$xml = Get-GPOReport -Name "Super Important Drive Mapping" -ReportType Xml

## There's data hiding out in here but I'm having a hard time extracting it from the xml format.
## Examples: (uncomment any of the lines below to see some part of xml doc)
# $xml.GPO.User.ExtensionData.Extension.DriveMapSettings.Drive
# $xml.GPO.User.ExtensionData.Extension.DriveMapSettings.Drive.Name
# $xml.GPO.User.ExtensionData.Extension.DriveMapSettings.Drive.Properties.Path

## I've also tried to loop through the drives in order to extract things and put them into a table, but that hasn't really worked.
## What I have found is something like this...
# foreach($drive in $xml.GPO.User.ExtensionData.Extension.DriveMapSettings.Drive){$drive.Name + " maps to: " + $drive.Properties.Path}

$data = @()
$drive = New-Object PSObject
foreach($drive in $xml.GPO.User.ExtensionData.Extension.DriveMapSettings.Drive){
    $data += $drive.Name
    $data += $drive.Properties.Path}
$data | Out-File ".\gpo-drives.csv"