## Requires: RSAT, PSSlack, and a Slack webhook with posting permissions to your specified channel.

$leases=@()
$fields=@()
$slackattachments=@()
$uri = "https://hooks.slack.com/services/T##########/B##########/abc###abc###avc###abc###"

foreach ($dhcp in Get-DhcpServerInDC){
    $leases += Get-DhcpServerv4Scope `
        -ComputerName $dhcp.DnsName `
        -ErrorAction SilentlyContinue `
        -WarningAction SilentlyContinue `
            | Get-DhcpServerv4Lease `
                -ComputerName $dhcp.DnsName `
                -ErrorAction SilentlyContinue `
                -WarningAction SilentlyContinue `
                    | Where-Object {$_.HostName -like '*.mil' -or $_.HostName -like '*.gov'} `
                    | Select-Object Hostname,`
                        @{N='IP Address'; E={$_.IPAddress.ToString()}},`
                        @{N='DHCP Server'; E={$_.ServerIP}},`
                        @{N='MAC Address'; E={$_.ClientId}},`
                        @{N='Lease Expiration'; E={$_.LeaseExpiryTime.ToString()}}
    }
foreach ($lease in $leases){
    Add-DhcpServerv4Filter `
        -ComputerName $lease.'DHCP Server' `
        -List Deny -MacAddress $lease.'MAC Address' `
        -Description ($lease.Hostname + " **Auto add via DHCP scrub script.**") `
        -ErrorAction SilentlyContinue `
        -WarningAction SilentlyContinue
    Remove-DhcpServerv4Lease `
        -ComputerName $lease.'DHCP Server' `
        -IPAddress $lease.'IP Address' `
        -ErrorAction SilentlyContinue `
        -WarningAction SilentlyContinue
    foreach($prop in $lease.psobject.properties.name){
    $fields += @{
        title = $prop
        value = $lease.$prop
        short = $true}
    }
    $slackattachments += New-SlackMessageAttachment `
        -Color $_PSSlackColorMap.red `
        -Title 'Non-Company device discovered in DHCP' `
        -Text '_Device block has been automatically attempted._' `
        -Fields $fields `
        -Fallback 'DHCP Alert!'

New-SlackMessage -Attachments $slackattachments | Send-SlackMessage -Uri $Uri
$leases=@()
$fields=@()
$slackattachments=@()
}