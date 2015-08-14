###########################################################################
#
# NAME: (Pure Storage) Restore most recent protection group volumes
#			on a target array.
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: Use this script to grab the most recently replicated snapshot
#			from each protection group on a taget array and restore/copy
#			out as pure volumes.
#				** Script does not assign new volumes to a host/group.
#				** This can either be done manually after volume creation
#				** or by adding '-Hostname "hostabc123"' to the 
#				** Restore-PfaProtectionGroupVolumeSnapshots command below.
#			Note: If volume is protected by multiple PGs. Script will skip
#					additional volume creation because of duplicate names.
#
# VERSION HISTORY:
# 1.0 8/11/2015 - Initial release
#
###########################################################################
# Import appropriate module (if not already added)
Import-Module PureStoragePowerShell

# Gather information from the user
$faip = Read-Host "Enter the IP or FQDN of the array you'd like to work from"
$pfxlabel = Read-Host "Enter the prefix label to be used for snapshot copies"

# Connect to session/controller and pull list of PGs
$pfasession = Get-PfaAPIToken -FlashArray $faip -Credential(Get-Credential) | Connect-PfaController
$pfagroups = (Get-PfaProtectionGroups -FlashArray $faip -Session $pfasession).name

# Loop through each PG name
foreach ($name in $pfagroups) {
	# Determine the last fully replicated snap for that PG
	$helper = Get-PfaProtectionGroupTransferStatisics -FlashArray $faip -Session $pfasession -Name $name | Where-Object {$_.progress -eq 1.0} | Select-Object -First 1
	# Make sure the previous step returned something (can be null if there are no snaps or if none have fully replicated)
	if (-not ($helper -eq $null)) {
		# Divy up the snapshot details so we can pass them to the restore command
		$pgsourcename = $helper.name.Split(".")[0]
		$snapname = $helper.name
		Write-Host "$faip | Restoring all volumes from: $snapname (group: $pgsourcename) using the prefix $pfxlabel"
		Restore-PfaProtectionGroupVolumeSnapshots -FlashArray $faip -ProtectionGroup $pgsourcename -SnapshotName $snapname -Prefix $pfxlabel -Session $pfasession
	}
}
