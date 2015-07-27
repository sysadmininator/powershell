###########################################################################
#
# NAME: AD User Account Details
#
# AUTHOR:  Andrew Reeves
#
# COMMENT:	1. Execute script to see a common set of user details.
#			2. Uncomment blocks as needed to gather additional information
#				(i.e. User information from another domain controller)
#
# VERSION HISTORY:
# 1.0 2/21/2013 - Initial release
# 1.1 2/25/2013 - Added prompt for username/info.
#
###########################################################################


$username = Read-Host -Prompt "Enter a user, first, or last name (accepts partials with or without '*' wildcard) :"

Get-QADUser -Identity $username | Select-Object CreationDate,LogonName,FirstName,LastName,Title,Email,ParentContainer,AccountIsLockedOut,AccountIsDisabled,UserMustChangePassword,PasswordIsExpired,PasswordStatus,PasswordExpires,AccountExpires,LastLogon


#### Retrieve user information from a specific domain controller.
$domaincontroller = Read-Host -Prompt "Enter a domain controller to check against:"
Get-QADUser $username -Service $domaincontroller | Select LogonName,Title,Email,ParentContainer,AccountIsLockedOut,AccountIsDisabled,UserMustChangePassword,PasswordIsExpired,PasswordStatus,PasswordExpires,AccountExpires


#### Retrieve group memberships for a given user.
Get-QADGroup -ContainsMember $username | Sort-Object GroupName | Select-Object GroupName,ParentContainer,GroupScope,GroupType,Description