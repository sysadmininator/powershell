<#  Older helper script we used before a proper permissions audit tool/process was put in place.
    Keeping around to show where we've been... also some of the Get-ChildItem lines are fun.

The process used to go something like this:
 1. Make a new folder
 2. Copy this script to that folder
 3. Create a text file named after the server to audit (someserver.txt)
 4. Populate server text file with share names (one per line)
 5. Create a text file called groups.txt
 6. Populate groups.txt with group names (one per line)
 7. Execute this script
#>

$workdir = $PSScriptRoot

#### Get folder lists from server text file ####
$server = (Get-ChildItem -Path $workdir\* -Include *.txt -Exclude groups.txt).BaseName
$shares = Get-Content "$workdir\$server.txt"
Foreach ($share in $shares){
$share | Out-File -Append -FilePath "$workdir\$server-$share.csv"
Get-ChildItem -Path "\\$server\$share" | Where-Object{($_.PSIsContainer)} | foreach-object{$_.Name} | Out-File -Append -FilePath "$workdir\$server-$share.csv"
}

#### Get groups from groups.txt ###
$groups = Get-Content "$workdir\groups.txt"
Foreach ($group in $groups){
$group | Out-File -Append -FilePath "$workdir\$group.txt"
Get-ADGroup -Filter "Name -like '$group'" | Get-ADGroupMember | sort | Select -ExpandProperty Name | Out-File -Append -FilePath "$workdir\$group.txt"
}