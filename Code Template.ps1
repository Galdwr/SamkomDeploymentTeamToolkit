## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Run script in users context?
# yes or no
$Global:RunAsUser="no"

## Display a message for the user?
# yes or no
$Global:ShowDisplayMessage="no"
$Global:DisplayMessage="Put your message here"

$Global:loggedonuser = tasklist /v /FI "IMAGENAME eq explorer.exe" /FO list | find "User Name:"
$Global:loggedonuser = $loggedonuser.Substring(14)
$Global:loggedonuser = $loggedonuser -replace '.*?\\(.*)', '$1'

$searcher = [adsisearcher]"(samaccountname=$loggedonuser)"

## Main code for the script/fixes
if ($RunAsUser -eq "yes" -and $RunningFromPowershell -eq "yes") {
    ## When RunAsUSer is yes, this section must be used to execute code for system and the possibility to execute
    ## system commands depending on user location is not avaliable

    }
    else {
        if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
        {
        ## When RunAsUser is yes, the three sections below executes code in the users context
        ## and when RunAsUser is no it's executed in the systems context

        ## Execute code for Ulricehamn
        
        
        }
        else {
        ## Execute code for Tranemo
        
        
        }
        ## Execute code for everyone
        
                
    }


## ---------------------------------------------------

## Examples

## Powershell does not pause when an exe is executed. Use the following line to execute and pause until finished, just duplicate if more then one exe needs to be executed
# start-process ExeFileNameHere.exe -Wait
# Example: start-process c:\temp\ccmsetup.exe /uninstall -Wait

## Working with registry.
# Create a key: New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup' -type Directory -Force -ErrorAction SilentlyContinue
# Edit or create a value: New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup]' -Name 'Prelogon' -Value "1" -PropertyType string -Force -ea SilentlyContinue;
