###########################################################################
#
# NAME: Samba File Refresh Fix
#
# AUTHOR:  Andrew Reeves
#
# COMMENT: Corrects a bug in SMB 2.0 that delays files from showing in
#			mapped drives.
#
# USAGE:   Script will prompt for admin credentials (domain\useraccount) and
#			computer to which the fix will be applied.
#			Script will output reg values on successful add. Verify with
#			regedit locally to confirm.
#
# VERSION HISTORY:
# 1.0 12/3/2013 - Initial release
#
###########################################################################

# Collect some information about the admin user and computer to be worked on.
$cred = Get-Credential
$comp = Read-Host "Enter the computer name to be modified:"

# Define the registry path to be worked with once connected.
$regpath = "HKLM:\System\CurrentControlSet\Services\Lanmanworkstation\Parameters"

# Connect remotely (local works too) using credentials and cd to system registry path.
Enter-PSSession $comp -Credential $cred
Set-Location HKLM:\System

# Test for existence of required reg path. If it doesn't exist, create it and add the SMB fix keys.
# If it does exist, simply add the keys.
If(-not(Test-Path -Path $regpath))
	{
	New-Item -Path $regpath -Force
	New-ItemProperty -Name DirectoryCacheLifetime -PropertyType DWORD -Value 0 -Path $regpath
	New-ItemProperty -Name FileNotFoundCacheLifetime -PropertyType DWORD -Value 0 -Path $regpath
	New-ItemProperty -Name FileInfoCacheLifetime -PropertyType DWORD -Value 0 -Path $regpath
	}
Else
	{
	New-ItemProperty -Name DirectoryCacheLifetime -PropertyType DWORD -Value 0 -Path $regpath
	New-ItemProperty -Name FileNotFoundCacheLifetime -PropertyType DWORD -Value 0 -Path $regpath
	New-ItemProperty -Name FileInfoCacheLifetime -PropertyType DWORD -Value 0 -Path $regpath
	}

# Disconnect and clean up.
Exit-PSSession
Set-Location c:\