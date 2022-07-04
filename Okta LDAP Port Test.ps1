<#
    Helper script I ran once or twice trying to narrow down issues with our Okta LDAP service.
    
    Output should be a log file with a nicely formatted timestamp that gives a better idea as
    to when (and with which Okta datacenter IPs) your ldap connections might be struggling.
    Tests connectivity every 30 seconds until stopped.

    ! Modify the domain.ldap.okta.com domain below to match your tenant.
#>


filter timestamp {"$('[{0:MM/dd/yyyy} {0:HH:mm:ss}]' -f (Get-Date)) $_"}

$outfile = ".\oktaldap.log"

While ($true){
    "**********" *>> $outfile
    Get-Date *>> $outfile
    "**********" *>> $outfile
    $resolvedips = Resolve-DnsName domain.ldap.okta.com
    $resolvedips *>> $outfile
    $resolvedips.IP4Address  *>> $outfile
    foreach($ip in $resolvedips.ip4address){Test-NetConnection -ComputerName $ip -Port 636 *>> $outfile}
    Start-Sleep -Seconds 30
}