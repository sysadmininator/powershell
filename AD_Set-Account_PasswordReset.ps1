###########################################################################
#
# NAME: Reset/Change AD Password.
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: Run this script to change AD password for a given user.
#
# VERSION HISTORY:
# 1.0 02/26/2013 - Initial release
# 2.0 03/12/2013 - Added exit/cancel option.
# 2.1 12/31/2015 - Convert Quest cmdlets to native MS AD.
#
###########################################################################

# Get the username.
$username = Read-Host "Enter the users account name:"

# Get new password (as secure string).
$pwd_secure = read-host "Enter a new password:" -assecurestring

# Force user to change password at next logon?
$optchangepwd = Read-Host "Force password reset on next logon? ([Y]es | [N]o | [C]ancel)"
if (($optchangepwd -eq "y") -or ($optchangepwd -eq "yes"))
	{
	Unlock-ADAccount $username
	Set-ADAccountPassword -Identity $username -NewPassword $pwd_secure -reset
	Set-ADUser -Identity $username -ChangePasswordAtLogon $true
	Write-Host "Password changed. User must change password during next logon attempt."
	}
elseif (($optchangepwd -eq "n") -or ($optchangepwd -eq "no"))
	{
	Unlock-ADAccount $username
	Set-ADAccountPassword -Identity $username -NewPassword $pwd_secure -reset
	Write-Host "Password changed. User will NOT be required to change password during next logon attempt."
	}
elseif (($optchangepwd -eq "c") -or ($optchangepwd -eq "cancel") -or ($optchangepwd -eq $null))
	{
	Write-Host "Cancel (or no input) received. No changes have been made to $username."
	}
else {Write-Host "Input not understood. No changes have been made to username: $username. Please try again."}

# Verify changes by displaying account stats.
Get-ADUser -Identity $username -Properties * | Select Name,SamAccountName,Title,EmailAddress,CanonicalName,LockedOut,BadLogonCount,BadPwdCount,AccountLockoutTime,LastBadPasswordAttempt,PasswordExpired,PasswordLastSet,AccountExpirationDate,Enabled
