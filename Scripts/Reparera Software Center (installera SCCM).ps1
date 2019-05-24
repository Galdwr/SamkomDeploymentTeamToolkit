## Samkom DeploymentTeam Toolkit Template

## By default this script executes commands for the machine and not the user. Se the examples below to execute commands in the users context

## Choose exit behaviour
# reboot, logout or exit
$ExitWay="exit"

## Display message for the user
# yes or no
$ShowDisplayMessage="yes"
$DisplayMessage="Reparationen är klar"

$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
$loggedonuser=$env:USERNAME

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
$TARGETDIR = 'c:\temp'
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

Copy-Item "\\gsccm.samkom.se\Utils\SccmUtil\clientinst\*" -Destination $TARGETDIR -Recurse

$GetProcessJob = Start-Job -ScriptBlock {$TARGETDIR + "\sccmsetup.exe /uninstall"}
Wait-Job $GetProcessJob

$GetProcessJob = Start-Job -ScriptBlock {$TARGETDIR + "\sccmsetup.exe /install"}
Wait-Job $GetProcessJob

## ---------------------------------------------------
## Examples

## Powershell does not wait when an exe is executed. Use the following two lines to execute and wait, just duplicate if more then one exe need to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob