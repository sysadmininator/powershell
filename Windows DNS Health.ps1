<# DNS Health Script

    This script runs DCDiag tests to validate DNS delegation  
    $OutputPath should have a number of files/reports in it when complete.
    
    Some of these steps can take a long time depending on your env. 
    
    Change the variables below to match your env.
#>

#### Change These ####
$OutputPath = "c:\DNSHealthReports"
$intns = "internal-dns-server.domain.com"
$extns = "external-dns-server.domain.com"
########

# Checks/creates for specified output path.
if( -Not (test-path $OutputPath ))
{
New-Item -Path $OutputPath -ItemType directory
}

# Run dcdiag DNS tests and output to xml with errors to a separate txt file
dcdiag.exe /test:dns /dnsdelegation /v /e /q /x:$OutputPath\dcdiag.xml /xsl:$OutputPath\dcdiag.xsl /e /q /s:$intns /f:$Outputpath\DNSHealthErrors.txt
 
# Now pull the XML into an object and start manipulating it 
[System.Xml.XmlDocument] $XD = new-object System.Xml.XmlDocument 
$XD.Load("$OutputPath\dcdiag.xml") 

# Exports the 50 latest event logs from internal NS
Get-EventLog -ComputerName $intns -Newest 50 -EntryType Error,warning -logname 'DNS Server' | select EntryType,InstanceID,Message,Source,TimeGenerated,Username | fl | Out-File -FilePath $OutputPath\Internal_DNS_Server_log.txt

# Exports the 50 latest event logs from external NS
Get-EventLog -ComputerName $extns -Newest 50 -EntryType Error,warning -logname 'DNS Server' | select EntryType,InstanceID,Message,Source,TimeGenerated,Username | fl | Out-File -FilePath $OutputPath\External_DNS_Server_log.txt

# Exports the 50 latest event logs from internal DFS replication
Get-EventLog -ComputerName $intns -Newest 50 -EntryType Error,warning -logname 'DFS Replication' | select EntryType,InstanceID,Message,Source,TimeGenerated,Username | fl | Out-File -FilePath $OutputPath\DFS_Replication_log.txt

# Run a DNS replication report
repadmin /showrepl >> $OutputPath\ReplicationReport.txt

# This checks if DNS Scavenging is turned on for internal NS
Get-DnsServerScavenging -ComputerName $intns | Out-File $OutputPath\DNSScavengeInfo.txt

# Perform static IP checks against internal NS
$results = @()
$zones = (Get-DnsServerZone -ComputerName $intns).ZoneName
foreach ($zone in $zones){
$statics = Get-DnsServerResourceRecord -ZoneName $zone -ComputerName $intns -RRType A | where {-not $_.TimeStamp}

# Loop through static records and resolve/ping the entry... add it to the results array if it fails
foreach ($static in $statics){
    $results += Test-NetConnection -ComputerName ($static.HostName + "." + $zone) | where {$_.PingSucceeded -eq $false}
}}
# Filter out prefix/root records then display resolution and connection failures
$results | ? {$_.NameResolutionSucceeded -eq "TRUE"} | Select ComputerName,RemoteAddress,ResolvedAddresses,PingSucceeded,TcpTestSucceeded | ft | out-file $OutputPath\Internal_DNS_ConnFailures.txt

# Clear the array and perform the same check for external NS
$results = @()
$zones = (Get-DnsServerZone -ComputerName $extns).ZoneName
foreach ($zone in $zones){
$statics = Get-DnsServerResourceRecord -ZoneName $zone -ComputerName $extns -RRType A | where {-not $_.TimeStamp}

# Loop through static records and resolve/ping the entry... add it to the results array if it fails
foreach ($static in $statics){
    $results += Test-NetConnection -ComputerName ($static.HostName + "." + $zone) | where {$_.PingSucceeded -eq $false}
}}
# Filter out prefix/root records then display resolution and connection failures
$results | ? {$_.NameResolutionSucceeded -eq "TRUE"} | Select ComputerName,RemoteAddress,ResolvedAddresses,PingSucceeded,TcpTestSucceeded | ft | out-file $OutputPath\External_DNS_ConnFailures.txt


# Run DNS Scavenging on internal and external NS
    #! IMPORTANT: Uncomment/run only if you are certain your scavenging settings are correct
    #! IMPORTANT: Incorrect settings WILL result in DNS issues
<#
Start-DnsServerScavenging -ComputerName $intns -force
Start-DnsServerScavenging -ComputerName $extns -force
#>