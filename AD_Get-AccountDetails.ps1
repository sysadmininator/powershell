###########################################################################
#
# NAME: AD User Account Details
#
# AUTHOR:  areeves
#
# COMMENT:	1. Execute script to see a common set of user details.
#			2. Uncomment blocks as needed to gather additional information
#				(i.e. User information from another domain controller)
#
# VERSION HISTORY:
# 1.0 2/21/2013 - Initial release
# 1.1 2/25/2013 - Added prompt for username/info.
# 1.2 12/31/2015 - Convert Quest cmdlets to native MS AD.
#
###########################################################################


$username = Read-Host -Prompt "Enter a username"
Get-ADUser -Identity $username -Properties * | Select Created,Name,SamAccountName,GivenName,Surname,Title,EmailAddress,CanonicalName,LastLogonDate,LockedOut,BadLogonCount,BadPwdCount,AccountLockoutTime,LastBadPasswordAttempt,PasswordExpired,PasswordLastSet,AccountExpirationDate,Enabled


#### Retrieve user information from a specific domain controller.
#$domaincontroller = Read-Host -Prompt "Enter a domain controller to check against"
#Get-ADUser -Identity $username -Server $domaincontroller -Properties * | Select Created,Name,SamAccountName,GivenName,Surname,Title,EmailAddress,CanonicalName,LastLogonDate,LockedOut,BadLogonCount,BadPwdCount,AccountLockoutTime,LastBadPasswordAttempt,PasswordExpired,PasswordLastSet,AccountExpirationDate,Enabled


#### Retrieve group memberships for a given user.
#Get-ADPrincipalGroupMembership -Identity $username
