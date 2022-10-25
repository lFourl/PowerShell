Import-Module ActiveDirectory

$sAMAccountName = Read-Host 'Enter SAM: '
$manager = Read-Host 'Enter manager SAM: '
$userEmail = "$($sAMAccountName)@yourorg.com"

$path = "\\path-to-server\folder\$($sAMAccountName)"
$dest= "\\path-to-server\folder\$($manager)"

## Disabling user account
Disable-ADAccount -Identity $sAMAccountName

## Remove all group membership
Get-ADUser -Identity $sAMAccountName -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
}

## Move to Disabled Users OU
Get-ADUser -Identity $sAMAccountName | Move-ADObject -TargetPath "<enter DC/OU Path>"

##Convert to shared mailbox and delegate access to manager
Set-Mailbox -Identity $userEmail -Type Shared
Add-MailboxPermission -Identity $userEmail -User $manager -AccessRights FullAccess -InheritanceType All

## Hide user mailbox
Set-Mailbox -Identity DOMAIN\$sAMAccountName -HiddenFromAddressListsEnabled $true

## Move user's private folder to manager
Move-Item -path $path -destination $dest

## Remove 365 License (Last thing!!)
Set-MsolUserLicense -UserPrincipalName $userEmail -RemoveLicenses "<AccountSkuId for Business Prem>"

## Change display name to reflect term date
$termDate = Get-Date -UFormat "%m.%d.%Y"
Set-MsolUser -UserPrincipalName $userEmail -DisplayName "$($termDate)$($sAMAccountName)"
