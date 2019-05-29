## Samkom DeploymentTeam Toolkit Template

## By default this script executes commands for the machine and not the user. Se the examples below to execute commands in the users context

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"
$Global:RunAsUser="no"
## Display message for the user
# yes or no
$Global:ShowDisplayMessage="yes"
$Global:DisplayMessage="Reparationen är klar, det kan ta upp till 10 minuter innan Software Center fungerar"

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

# Copy clientfiles
Start-Job -Name CopyFiles -ScriptBlock {Copy-Item "\\gsccm.samkom.se\Utils\SccmUtil\clientinst\*" -Destination 'c:\temp' -Recurse -ErrorAction SilentlyContinue} 
Wait-Job -Name CopyFiles

# Uninstall SCCM client
start-process C:\temp\ccmsetup.exe /uninstall -Wait

# Install SCCM client
start-process c:\temp\ccmsetup.exe SMSSITECODE=P01 -Wait


## ---------------------------------------------------
## Examples

## Powershell does not wait when an exe is executed. Use the following line to execute and wait, just duplicate if more then one exe need to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE} | Wait-Job