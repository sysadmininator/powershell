###########################################################################
#
# NAME: Show Mailbox Size (Active/Archive) for All Accounts.
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: 	Use this script to retrieve a formatted table of all mailbox
#			sizes (active and archive) with storage limit status,
#			last logon time, and database name (sorted by size).
#			Optional: Output results to CSV.
#			NOTE: Be sure to close your folder path if not using the
#				  default setting.
#					e.g. C:\FolderA\FolderB\FileName
#				  The script will append "_Active.csv" and
#				  "_Archive.csv" to the specified path.
#
# VERSION HISTORY:
# 1.0 2/28/2013 - Initial release
#
###########################################################################

# Retrieve local mailbox server name.
$server = Get-MailboxServer

# Get mailbox sizes for all accounts, format them into a table.
## "-ErrorAction SilentlyContinue" in rows 28, 39, and 44 supresses warnings caused by accounts not having associated archive mailboxes.
Get-Mailbox -Server $server | Get-MailboxStatistics | Sort-Object -Property TotalItemSize -Descending | Format-Table DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"},StorageLimitStatus,LastLogonTime,DatabaseName
Get-Mailbox -Server $server | Get-MailboxStatistics -Archive -ErrorAction SilentlyContinue | Sort-Object -Property TotalItemSize -Descending | Format-Table DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"},StorageLimitStatus,LastLogonTime,DatabaseName


# Output results to CSV file?
$optcsv = Read-Host "Output results to CSV? (Y | N)"
if (($optcsv -eq "y") -or ($optcsv -eq "yes"))
	{
		$csvpath = Read-Host "Specify an existing path for output: [Enter] for C:\ExStats_[Active/Archive].csv"
			if ($csvpath -eq $null)
				{
					Get-Mailbox -Server $server | Get-MailboxStatistics | Sort-Object -Property TotalItemSize -Descending | Select-Object DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"},StorageLimitStatus,LastLogonTime,DatabaseName | Export-Csv c:\ExStats_Active.csv -NoTypeInformation
					Get-Mailbox -Server $server | Get-MailboxStatistics -Archive -ErrorAction SilentlyContinue | Sort-Object -Property TotalItemSize -Descending | Select-Object DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"},StorageLimitStatus,LastLogonTime,DatabaseName | Export-Csv c:\ExStats_Archive.csv -NoTypeInformation
				}
			elseif ($csvpath -ne $null)
				{
					Get-Mailbox -Server $server | Get-MailboxStatistics | Sort-Object -Property TotalItemSize -Descending | Select-Object DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"},StorageLimitStatus,LastLogonTime,DatabaseName | Export-Csv -Path ($csvpath + "_Active.csv") -NoTypeInformation
					Get-Mailbox -Server $server | Get-MailboxStatistics -Archive -ErrorAction SilentlyContinue | Sort-Object -Property TotalItemSize -Descending | Select-Object DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"},StorageLimitStatus,LastLogonTime,DatabaseName | Export-Csv -Path ($csvpath + "_Archive.csv") -NoTypeInformation
				}
	}
elseif (($optcsv -eq "n") -or ($optcsv -eq "no"))
	{
		Write-Host "Operation canceled. No CSV outputs delivered."
	}
else {Write-Host "Input not understood. No CSV outputs delivered. Please try running the script again."}