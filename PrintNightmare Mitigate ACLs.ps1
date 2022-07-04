# Not meant to be run all at once.
## Needs cleanup and below is meant to be run in blocks depending on what is required.

# 'Deny' SYSTEM access to print spooler folder.
$Path = "C:\Windows\System32\spool\drivers"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Ar = New-Object  System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.AddAccessRule($Ar)
Set-Acl $Path $Acl


# 'Allow' SYSTEM access to print spooler folder.
# Use this if/when additional printers need to be added/removed/updated/modified.
# Run the block above after making any necessary changes to restrict access again.
$Path = "C:\Windows\System32\spool\drivers"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.RemoveAccessRule($Ar)
Set-Acl $Path $Acl