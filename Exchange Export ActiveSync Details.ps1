# Generate a list of which users have ActiveSync enabled on their mailbox.
Get-CASMailbox -ResultSize unlimited -Filter {activeSyncEnabled -eq $true} | Select-Object Name, ActiveSyncEnabled, PopEnabled, ImapEnabled | Export-Csv .\ActiveSyncEnabled.csv

# Generate a list of users that have devices associated with their mailbox.
Get-ActiveSyncDevice | Select-Object UserDisplayName, DeviceType, DeviceModel, DeviceUserAgent, DeviceId | Export-Csv .\ActiveSyncDevices.csv

# Generate a more detailed list of devices associated with mailboxes.
$devices = @()
$mailboxes = Get-CASMailbox -ResultSize:Unlimited | Where-Object {$_.HasActiveSyncDevicePartnership -eq $true -and $_.ExchangeVersion.ExchangeBuild -ilike "14*"}
foreach ($m in $mailboxes)  
{     
$devices += Get-ActiveSyncDeviceStatistics $m.Name
}
$devices | Export-Csv .\ActiveSyncDevices-Verbose.csv