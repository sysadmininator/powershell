$computers = Get-ADComputer -Filter {Enabled -eq 'true' -and OperatingSystem -like 'Windows Server*'}
$progress = 0
$CompCount = $Computers.Count

foreach ($comp in $computers){
	$Computer = $comp.Name
    write-host $computer
    invoke-command -computername $computer -scriptblock {query user}
    $progress++
    Write-Progress -activity "Working..." -status "Status: $progress of $CompCount Computers checked" -PercentComplete (($progress/$Computers.Count)*100)
}