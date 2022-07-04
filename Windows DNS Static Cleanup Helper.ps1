## Pulls DNS records from specified server and iterates a quick test-netconnection for all static records.
## Outputs all records that fail. Can be used for further verification/cleaning of your zone(s).
#! Change 'dc1' below to your specified DNS/DC hostname.

$dc = "dc1"
$results = @()

# grab all available zones from specifiec dns/dc
$zones = (Get-DnsServerZone -ComputerName $dc).ZoneName

# loop through zones to grab static records
foreach ($zone in $zones){
$statics = Get-DnsServerResourceRecord -ZoneName $zone -ComputerName $dc -RRType A | where {-not $_.TimeStamp}

# loop through static records and resolve/ping the entry... add it to the results array if pings fail.
foreach ($static in $statics){
    $results += Test-NetConnection -ComputerName ($static.HostName + "." + $zone) | where {$_.PingSucceeded -eq $false}
}}

# filter out prefix/root records then display resolution and connection failures
$results | ? {$_.NameResolutionSucceeded -eq "TRUE"} | Select ComputerName,RemoteAddress,ResolvedAddresses,PingSucceeded,TcpTestSucceeded | ft