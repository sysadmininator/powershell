###########################################################################
#
# NAME: Single User Mailbox and Folder Sizes.
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: 	Use this script to obtain the active, archive, and individual
#			folder sizes for a specified mailbox.
#
# VERSION HISTORY:
# 1.0 2/28/2013 - Initial release
#
###########################################################################

$username = Read-Host -Prompt "Enter a username or email address (does NOT accept partials or wilcards) :"

# Get active/archive mailbox sizes and convert to MB.
Get-MailboxStatistics -Identity $username | Format-Table DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"}
Get-MailboxStatistics -Identity $username -Archive | Format-Table DisplayName,@{expression={$_.totalitemsize.value.ToMB()};Name="Mailbox Size (MB)"}

Get-Mailbox -Identity $username | Format-List IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,ArchiveWarningQuota,ArchiveQuota

# Get mailbox folder list with item count and size (sorted by folder size).
Get-MailboxFolderStatistics -Identity $username -FolderScope all | Select-Object name,itemsinfolder,foldersize | Sort-Object foldersize -Descending
Write-Host "---- Archived Email Folders ----"
Get-MailboxFolderStatistics -Identity $username -Archive -FolderScope all | Select-Object name,itemsinfolder,foldersize | Sort-Object foldersize -Descending