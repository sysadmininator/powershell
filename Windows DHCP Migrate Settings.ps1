## Helper script to transfer DHCP server settings from one system to another.
## Moves the following: scope, dns, options, reservations, and filters.
## Not sure why I left the '-WhatIf's but if this ends up being helpful to anyone else you'll obviously need to remove those before a real run ;).

#! Change these names
$srcdc = "sourcedhcpserver.domain.com"
$destdc = "destdhcpserver.domain.com"

#Something borrowed, something new...
$subnetIP = Get-DhcpServerv4Scope -ComputerName $srcdc
Get-DhcpServerv4Scope -ComputerName $srcdc | Add-DhcpServerv4Scope -ComputerName -State Inactive $destdc -WhatIf
Get-DhcpServerv4DnsSetting -ComputerName $srcdc | Set-DhcpServerv4DnsSetting -ComputerName $destdc -WhatIf
Get-DhcpServerv4OptionValue -ComputerName $srcdc -ScopeId $subnetIP.ScopeId | Set-DhcpServerv4OptionValue -ComputerName $destdc -WhatIf
Get-DhcpServerv4Reservation -ComputerName $srcdc -ScopeId $subnetIP.ScopeId | Set-DhcpServerv4Reservation -ComputerName $destdc -WhatIf
Get-DhcpServerv4Filter -ComputerName $srcdc | Add-DhcpServerv4Filter -ComputerName $destdc -WhatIf