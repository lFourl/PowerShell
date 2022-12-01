$firstName = Read-Host 'Enter first name: '
$lastName = Read-Host 'Enter last name: '
$department = Read-Host 'Enter department: '
$position = Read-Host 'Enter Position Title: '
$manager = Read-Host 'Reports to: '
$location = Read-Host 'Located at: '
$model = Read-Host 'Employee Model: '
$emailGroup = Read-Host 'Email Groups: '

$copy = Get-ADUser -Identity $model
New-ADUser -Name "$($firstName) $($lastName)" -GivenName $firstName -Surname $lastName -SAMAccountName "$($firstName[0])$($lastName)" -Instance $copy -DisplayName "$($firstName) $($lastName)" -AccountPassword (ConvertTo-SecureString Welcome@2022 -AsPlainText -Force)

Set-ADUser -Identity "$($firstName[0])$($lastName)" -Description $position -Manager $manager -Office $location

Add-ADGroupMember -Identity $emailGroup -Members "$($firstName[0])$($lastName)"

Set-MsolUserLicense -UserPrincipalName """$($firstName[0])$($lastName)""@helptucson.org" -AddLicenses "Oasis:Business Premium"

