## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Run script in users context?
# yes or no
$Global:RunAsUser="no"
# If the script running in users context takes more then 5 seconds to execute, change it below
$Global:WaitforTask = 5

## Display a message for the user
# yes or no
$Global:ShowDisplayMessage="no"
$Global:DisplayMessage="Rensningen är utförd"

#$loggedonuser=$env:USERNAME
$loggedonuser = tasklist /v /FI "IMAGENAME eq explorer.exe" /FO list | find "User Name:"
$loggedonuser = $loggedonuser.Substring(14)
$Global:loggedonuserTask
#$Credential = $loggedonuser
$loggedonuser = $loggedonuser -replace '.*?\\(.*)', '$1'

$searcher = [adsisearcher]"(samaccountname=$loggedonuser)"

## Main code for the script/fixes
if ($RunAsUser -eq "yes" -and $RunningFromPowershell -eq "yes") {
    ## If RunAsUSer is yes, this section must be used to execute code for system.

    }
    else {
        if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
        {
        ## Execute code for Ulricehamn
        
        
        }
        else {
        ## Execute code for Tranemo
        
        
        }
        ## Execute code for everyone
        #Clear items older then 7 days from SCCM-cache
        $x=(New-Object -Com UIResource.UIResourceMgr).GetCacheInfo();$x.GetCacheElements()|Where-Object{$_.LastReferenceTime-lt(Get-Date).AddDays(-7)}|ForEach-Object{$x.DeleteCacheElement($_.CacheElementID)}
        
        #Cleanup temp folders, IE-cache and winupdate
        Function Cleanup { 
        function global:Write-Verbose ( [string]$Message ) 
 
        # check $VerbosePreference variable, and turns -Verbose on 
        { if ( $VerbosePreference -ne 'SilentlyContinue' ) 
        { Write-Host " $Message" -ForegroundColor 'Yellow' } } 
 
        $VerbosePreference = "Continue" 
        $DaysToDelete = 1 
        $LogDate = get-date -format "MM-d-yy-HH" 
        $objShell = New-Object -ComObject Shell.Application  
        $objFolder = $objShell.Namespace(0xA) 
        $ErrorActionPreference = "silentlycontinue" 
                     
        Start-Transcript -Path C:\Windows\Temp\$LogDate.log 
        
        ## Cleans all code off of the screen. 
        Clear-Host 
        
        $size = Get-ChildItem C:\Users\* -Include *.iso, *.vhd -Recurse -ErrorAction SilentlyContinue |  
        Sort-Object Length -Descending |  
        Select-Object Name, 
        @{Name="Size (GB)";Expression={ "{0:N2}" -f ($_.Length / 1GB) }}, Directory | 
        Format-Table -AutoSize | Out-String 
        
        $Before = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName, 
        @{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } }, 
        @{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}}, 
        @{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } }, 
        @{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } | 
        Format-Table -AutoSize | Out-String                       
                            
        ## Stops the windows update service.  
        Get-Service -Name wuauserv | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue 
        ## Windows Update Service has been stopped successfully! 
        
        ## Deletes the contents of windows software distribution. 
        Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
        ## The Contents of Windows SoftwareDistribution have been removed successfully! 
        
        ## Deletes the contents of the Windows Temp folder. 
        Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | 
        Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete)) } | 
        remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
        ## The Contents of Windows Temp have been removed successfully! 
                    
        ## Delets all files and folders in user's Temp folder.  
        Get-ChildItem "C:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | 
        Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete))} | 
        remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue 
        ## The contents of C:\users\$env:USERNAME\AppData\Local\Temp\ have been removed successfully! 
                            
        ## Remove all files and folders in user's Temporary Internet Files.  
        Get-ChildItem "C:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | 
        Where-Object {($_.CreationTime -le $(Get-Date).AddDays(-$DaysToDelete))} | 
        remove-item -force -recurse -ErrorAction SilentlyContinue 
        ## All Temporary Internet Files have been removed successfully! 
                            
        ## Cleans IIS Logs if applicable. 
        Get-ChildItem "C:\inetpub\logs\LogFiles\*" -Recurse -Force -ErrorAction SilentlyContinue | 
        Where-Object { ($_.CreationTime -le $(Get-Date).AddDays(-60)) } | 
        Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue 
        ## All IIS Logfiles over x days old have been removed Successfully! 
                        
        ## deletes the contents of the recycling Bin. 
        ## The Recycling Bin is now being emptied! 
        $objFolder.items() | ForEach-Object { Remove-Item $_.path -ErrorAction Ignore -Force -Verbose -Recurse } 
        ## The Recycling Bin has been emptied! 
        
        ## Starts the Windows Update Service 
        ##Get-Service -Name wuauserv | Start-Service -Verbose 
        
        $After =  Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName, 
        @{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } }, 
        @{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}}, 
        @{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } }, 
        @{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } | 
        Format-Table -AutoSize | Out-String 
        
        ## Sends some before and after info for ticketing purposes 
        
        Hostname ; Get-Date | Select-Object DateTime 
        Write-Verbose "Before: $Before" 
        Write-Verbose "After: $After" 
        Write-Verbose $size 
        ## Completed Successfully! 
        Stop-Transcript } Cleanup
            }


## ---------------------------------------------------

## Examples

## Powershell does not pause when an exe is executed. Use the following two lines to execute and pause until finished, just duplicate if more then one exe needs to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob

## Working with registry.
# Create a key: New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup' -type Directory -Force -ErrorAction SilentlyContinue
# Edit or create a value: New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup]' -Name 'Prelogon' -Value "1" -PropertyType string -Force -ea SilentlyContinue;
