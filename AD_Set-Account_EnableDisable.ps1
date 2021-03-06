###########################################################################
#
# NAME: Enable/Disable AD User Account
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: 	Add '-Server <domain controller>' to enable/disable account
#			on a specific DC. E.g. -Server bob1.company.net .
#
# VERSION HISTORY:
# 1.0 2/22/2013 - Initial release
#
###########################################################################


#### Enable AD account NOW!
#Enable-ADAccount $username -Verbose

#### Disable AD account NOW!
#Disable-ADAccount $username -Verbose

#### Disable AD account at a specific time.
#Set-ADUser $username -AccountExpirationDate "12/25/2020 5:00PM"

#### Set account to never expire.
#Set-ADUser $username -AccountExpirationDate:$null