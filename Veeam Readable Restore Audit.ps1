## Helper script to parse/output Veeam audit logs in a more human readable format.
## Requires: PSWriteHTML, VeeamPSSnapIn
Import-Module PSWriteHTML
Import-Module VeeamPSSnapIn #this module may fail to load... if so, use the shell launched from the VBR.


# Connect to a VBR server.
Connect-VBRServer -Server vbr.domain.com

# Pull a list of all VBR restore jobs, select relevent info, and output to HTML.
Get-VBRRestoreSession | Select Name,JobTypeString,CreationTime,@{n='Reason';e={$_.Info.Reason}},@{n='Initiator';e={$_.Info.Initiator.Name}},@{n='Results';e={$_.Logger.GetLog().UpdatedRecords.Title}} | Out-HtmlView