###########################################################################
#
# NAME: Add/Remove Full Access Mailbox Permissions.
#
# AUTHOR:  Andrew Reeves
#
# COMMENT:	Use this script to add or remove Full Access permissions for
#			a given user to a specified mailbox.
#
# VERSION HISTORY:
# 1.0 3/1/2013 - Initial release
#
###########################################################################

# Get name of the account you wish to make changes to.
$mbname = Read-Host "Enter the username or email address of the account you wish to modify:"

# Get name of the account to add/remove Full Access permissions.
$usermod = Read-Host "Enter the username or email address of the account to be attached/removed:"

# Ask whether this should be an addition or removal.
$askaddremove = Read-Host "Should 'Full Access' permissions be [A]dded or [R]emoved?:"

# Process permissions according to input.
if (($askaddremove -eq "a") -or ($askaddremove -eq "add") -or ($askaddremove -eq "added"))
	{
		Add-MailboxPermission -Identity $mbname -User $usermod -AccessRights FullAccess
	}
elseif (($askaddremove -eq "r") -or ($askaddremove -eq "remove") -or ($askaddremove -eq "removed"))
	{
		Remove-MailboxPermission -Identity $mbname -User $usermod -AccessRights FullAccess
	}
else {Write-Host "Input not understood. No changes have been made to username:" $mbname ". Please try again."}

# Verify?
$askverify = Read-Host "Verify changes?: (Y | N)"
if (($askverify -eq "y") -or ($askverify -eq "yes") -or ($askverify -eq $null))
	{
		Write-Host "Verifying..."
		$verify = Get-MailboxPermission -Identity $mbname -User $usermod
			if ($verify -eq $null)
				{
					Write-Host ("No permissions for " + $usermod + " exist on mailbox " + $mbname + ".")
				}
			else {Get-MailboxPermission -Identity $mbname -User $usermod | Select-Object Identity, User, AccessRights}
	}
elseif (($askverify -eq "n") -or ($askverify -eq "no"))
	{
		Write-Host "No verification requested. Operation complete."
	}
else {Write-Host "Input not understood. Verification canceled. Please try again."}