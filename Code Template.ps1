## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Run script in users context?
# yes or no
$Global:RunAsUSer="no"

## Display a message for the user
# yes or no
$Global:ShowDisplayMessage="no"
$Global:DisplayMessage="Put your message here"

$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
#$loggedonuser=$env:USERNAME

## Main code for the script/fixes
if ($RunAsUSer -eq "yes" -and $RunningFromPowershell -eq "yes") {
    }
    else {
        if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
        {
        ## Execute code for Ulricehamn users
        
        
         }
         else 
        {
        ## Execute code for Tranemo users
        
        
        }
        ## Execute code for everyone, always put your code here if you set RunAsUser to "no"
        
                
    }


## ---------------------------------------------------
## Examples

## Powershell does not pause when an exe is executed. Use the following two lines to execute and pause until finished, just duplicate if more then one exe needs to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob
