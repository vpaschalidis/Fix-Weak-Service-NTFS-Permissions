# Fix-Weak-Service-NTFS-Permissions
This script identifies and fixes weak NTFS permissions on Windows services binaries. 
It finds Windows path from where each Windows service is executing the binary and searches for NTFS permissions where the BUILTIN\Users and NT AUTHORITY\Authenticated Users group have FullControl,ChangePermissions, SetValue or TakeOwnership rights and removes them.

In order to run the script just execute the below in an elevated powershell:

.\Fix-Weak-Service-NTFS-Permissions.ps1
