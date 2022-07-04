## Helper script to analyze domain passwords against haveibeenpwned hash list.
## Also analyzes weak passwords and other quality issues.
## Requires: DSInternals, PSWinDocumentation.


Import-Module DSInternals
Import-Module PSWinDocumentation
Import-Module PSWinDocumentation.AD


$PathToPasswordsHashes = 'C:\path\to\pwned-passwords-ntlm-ordered-by-hash.txt'
$Passwords = Invoke-ADPasswordAnalysis -PathToPasswords $PathToPasswordsHashes -UseNTLMHashes

# Lists all available options/results that can be expanded.
$Passwords.'domain.com' | Format-Table Name

# List of accounts/hashes that appear in AD AND haveibeenpwned db.
$Passwords.'domain.com'.DomainPasswordWeakPassword | Format-Table

# Report of all password related issues found with accounts in the domain.
$Passwords.'domain.com'.PasswordQuality


<#
# Run separately for more information on an account and hashes detected.
$pqusers = $Passwords.'domain.com'.PasswordQualityUsers
$pqusers | Where-Object {$_.samaccountname -eq "jsmith"}
#>