## Samkom DeploymentTeam Toolkit Template

## By default this script executes commands for the machine and not the user. Se the examples below to execute commands in the users context

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"
$Global:RunAsUser="no"
## Display message for the user
# yes or no
$Global:ShowDisplayMessage="yes"
$Global:DisplayMessage="Reparationen är klar"

$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
#$loggedonuser=$env:USERNAME

## Main code for the fix

if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
{
## Execute code for Ulricehamn


 }
 else 
{
## Execute code for Tranemo


}

## Execute Common code
if(!(Test-Path -Path 'c:\temp' )){
    New-Item -ItemType directory -Path 'c:\temp'
}

# Copy clientfiles
Start-Job -Name CopyFiles -ScriptBlock {Copy-Item "\\gsccm.samkom.se\Utils\SccmUtil\clientinst\*" -Destination 'c:\temp' -Recurse -ErrorAction SilentlyContinue} 
Wait-Job -Name CopyFiles

# Uninstall SCCM client
Start-Job -Name CcmUninstall -ScriptBlock {start-process C:\temp\ccmsetup.exe /uninstall -Wait}
Wait-Job -Name CcmUninstall
#start-process C:\temp\ccmsetup.exe /uninstall -Wait

# Install SCCM client
Start-Job -Name CcmInstall -ScriptBlock {start-process c:\temp\ccmsetup.exe SMSSITECODE=P01 -Wait}
Wait-Job -Name CcmInstall
#start-process c:\temp\ccmsetup.exe SMSSITECODE=P01 -Wait


## ---------------------------------------------------
## Examples

## Powershell does not wait when an exe is executed. Use the following line to execute and wait, just duplicate if more then one exe need to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE} | Wait-Job