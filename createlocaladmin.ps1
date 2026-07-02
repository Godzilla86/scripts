#Creates a local administrator account
$username = Read-Host "Enter username for the user"
$password = Read-Host "Enter password for the user"
net user $username $password /add
net localgroup administrators $username /add

Write-Host "Local Administrator $username has been created"
