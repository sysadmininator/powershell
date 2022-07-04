$servers = (Get-ADComputer -Filter {(objectcategory -eq "computer") -AND (OperatingSystem -like '*Server*')})
$keywords = "*keyword1*","*keyword2*","*etc*"
$results = @()

foreach($server in $servers){
    Write-Output $server.DNSHostName
    Invoke-Command -ComputerName $server.DNSHostName -ScriptBlock {$drives = Get-PSDrive -PSProvider FileSystem
        foreach($drive in $drives){
            Write-Host $drive.root
            Get-ChildItem -Path $drive.root -Recurse -Include $keywords -ErrorAction SilentlyContinue | Select Name,Directory,CreationTime,LastAccessTime,LastWriteTime
            }}}