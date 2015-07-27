###########################################################################
#
# NAME: AD Computer Account Details
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: 	1. Execute script to see a common set of computer details.
#			2. Uncomment blocks as needed to gather additional information
#				(i.e. Computer information from another domain controller)
#
# VERSION HISTORY:
# 1.0 02/22/2013 - Initial release
# 1.1 02/25/2013 - Added prompt for computer name.
# 1.2 03/01/2013 - Added search by description field.
# 1.3 03/04/2013 - Added logic for multiple search parameters.
#
###########################################################################


$searchopt = Read-Host "Search by [C]omputer name or [D]escription field:"
if (($searchopt -eq "c") -or ($searchopt -eq $null))
	{
		# Search based on computer name/asset tag.
		$computername = Read-Host "Enter a computer name or TRI asset tag # (accepts partials and/or '*' wildcard) :"
		Get-QADComputer $computername | Select ComputerName,operatingSystem*,ParentContainer,Description,AccountIsDisabled
		
		## Uncomment the two lines below to have the script prompt for a domain controller name to check against.
		#$domaincontroller = Read-Host -Prompt "Enter a domain controller to check against:"
		#Get-QADComputer $computername -Service $domaincontroller | Select ComputerName,operatingSystem*,ParentContainer,Description,AccountIsDisabled
			$gpyn = Read-Host "Would you like to display current memberships for the computer account? (Y|N)"
			if (($gpyn -eq "y") -or ($gpyn -eq $null))
				{
				$computername+="$"
				Get-QADMemberOf -Identity $computername | Select GroupName,Description,ParentContainer,GroupScope,GroupType
				}
			else {Write-Host "Exiting..."}
	}
elseif ($searchopt -eq "d")
	{
		# Search based on keywords from the description field.
		$desckeyword = ("*" + (Read-Host "Search description field of all computers using the following keyword:") + "*")
		Get-QADComputer -Description $desckeyword | Select ComputerName,operatingSystem*,ParentContainer,Description,AccountIsDisabled
		
		## Uncomment the two lines below to have the script prompt for a domain controller name to check against.
		#$domaincontroller = Read-Host -Prompt "Enter a domain controller to check against:"
		#Get-QADComputer $computername -Service $domaincontroller | Select ComputerName,operatingSystem*,ParentContainer,Description,AccountIsDisabled
	}
else {Write-Host "Command not understood. Exiting now. Please try again."}