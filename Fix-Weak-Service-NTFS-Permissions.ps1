$services = @(Get-WmiObject win32_service | ?{$_.PathName -notlike '*C:\Windows\*'} | select Name, DisplayName, @{Name="Path"; Expression={$_.PathName.split('"')[1]}} )
foreach ($service in $services)
{
   $Path= $service.Path | Select-String -Pattern "^.*\\" -AllMatches | foreach {$_.matches.value}
   $acl = get-acl $Path   | Where-Object {($_.AccessToString -match "(BUILTIN\\Users|NT AUTHORITY\\Authenticated Users) Allow  [A-Za-z,\ ]{0,}(FullControl|Modify|ChangePermissions|SetValue|TakeOwnership)[A-Za-z,\ ]{0,}\n")}
   if($acl.count -gt 0){ 

        Write-Host "======== Current Status ========"
        Write-Host ""
        Write-Host "Service" $service.DisplayName "is vulnerable" $Path
        Write-Host ""
        Write-Host "====== Current Permissions ======"
        Write-Host ""
        Write-Host $acl.AccessToString
        Write-Host ""

        $rules = $acl.access | Where-Object { 
            (-not $_.IsInherited) 
        }
        ForEach($rule in $rules) {
            $acl.RemoveAccessRule($rule) | Out-Null
        }
            Set-ACL $Path -AclObject $acl 
            Write-Host "======== Updated Status ========"
            Write-Host ""
            Write-Host "Service" $service.DisplayName "is fixed"
            Write-Host ""
            Write-Host "====== Updated Permissions ======"
            Write-Host ""
            Write-Host $acl.AccessToString
            Write-Host ""
        }
}
