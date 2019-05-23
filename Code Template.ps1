## Samkom DeploymentTeam Toolkit Template

## By default this script executes commands for the machine and not the user. Se the examples below to execute commands in the users context

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Display message for the user
# yes or no
$Global:ShowDisplayMessage="no"
$Global:DisplayMessage="Put your message here"

$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
#$loggedonuser=$env:USERNAME

## Main code for the script/fix

if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
{
## Execute code for Ulricehamn


 }
 else 
{
## Execute code for Tranemo


}

## Execute Common code



## ---------------------------------------------------
## Examples

## Powershell does not pause when an exe is executed. Use the following two lines to execute and pause until finished, just duplicate if more then one exe needs to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob