###########################################################################
#
# NAME: Adjust Mailbox Quota Limits
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: Use this script to adjust quota limits on a named mailbox.
#			WARNING: CHECK VARIABLES BEFORE EACH RUN.
#
# VERSION HISTORY:
# 1.0 6/27/2013 - Initial release
#
###########################################################################

####!!!! VARIABLES - SET THESE BEFORE RUNNING !!!!####

#[Active] Issue Warning at:
$iwq = 1.8GB

#[Active] Prohibit Send at:
$psq = 2GB

#[Active] Prohibit Send and Receive at:
$psrq = 2GB

#[Archive] Issue Warning at:
$awq = 1.8GB

#[Archive] Prohibit Operation at:
$aq = 2GB

#### End Variable Set ####

$mbqname = Read-Host -Prompt "Enter a username or email address (does NOT accept partials or wilcards) :"

Write-Host "---- Quota Settings Before Adjustment ----"
Get-Mailbox -Identity $mbqname | Format-List DisplayName,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,ArchiveWarningQuota,ArchiveQuota

Set-Mailbox -Identity $mbqname -IssueWarningQuota $iwq -ProhibitSendQuota $psq -ProhibitSendReceiveQuota $psrq -ArchiveWarningQuota $awq -ArchiveQuota $aq

Write-Host "---- Current Quota Settings ----"
Get-Mailbox -Identity $mbqname | Format-List DisplayName,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,ArchiveWarningQuota,ArchiveQuota