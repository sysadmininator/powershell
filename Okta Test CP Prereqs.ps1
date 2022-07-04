## Helper script to verify if servers in your environment meet basic requirements to run the Okta Credential Provider.
## Checks for: 64-bit OS, .Net 4.6 min. version, TLS1.2, Okta CP installation status.
### there's also a quick GPO check, which we needed for other reasons. Output will only show failed GPOs, if detected.

$servers = Get-ADComputer -Filter {(objectcategory -eq "computer") -AND (OperatingSystem -like '*Server*')}
foreach ($server in $servers) {
    Write-Host $server.Name -backgroundcolor blue -foregroundcolor yellow
    Invoke-Command -ComputerName $server.DNSHostName -ScriptBlock {
        $is64bit = [IntPtr]::Size * 8 -eq 64
        Write-Host "Is 64-bit: $is64bit" -ForegroundColor Yellow
        $version = Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release
        # 394254 - .NET Framework 4.6.1, which is the current target of the installer
        if ($version.Release -ge 394254)  {
            $ev = [environment]::Version
            Write-Host ".NET 4.6 release version is at or above target:" $version.Release -ForegroundColor green
            Write-Host $ev -foregroundcolor darkgray
        }
        else {
            Write-Host ".NET 4.6 is not installed or not current. Check manually." -ForegroundColor red
        }

        $v = "v" + $ev.Major + "." + $ev.Minor + "." + $ev.Build
        $schCrypto = Get-ItemProperty -Path  "HKLM:\SOFTWARE\Microsoft\.NETFramework\$v\" -Name SchUseStrongCrypto -ErrorAction SilentlyContinue | Select SchUseStrongCrypto
        if ($schCrypto){
            Write-Host "SchUseStrongCrypto exists" -ForegroundColor Green
            Write-Host $schCrypto.SchUseStrongCrypto -ForegroundColor DarkGray
        }
        else {
            Write-Host "SchUseStrongCrypto doesn't seem to exist." -ForegroundColor Red
        }

        $gpout = gpupdate /force
        ($gpout |Select-String '(?<=\{)[^]]+(?=\})' -AllMatches).Matches.Value

        $software = "Okta Windows Credential Provider"
        $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

        If(-Not $installed) {
	        Write-Host "'$software' NOT is installed." -ForegroundColor Red
        } else {
	        Write-Host "'$software' is installed." -ForegroundColor Green
        }
}}