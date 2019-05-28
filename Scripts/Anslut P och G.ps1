## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Run script in users context?
# yes or no
$Global:RunAsUser="yes"
# If the script running in users context takes more then 5 seconds to execute, change it below
$Global:WaitforTask = 30 # *** In the future try to replace with a start-job and wait-job

## Display a message for the user
# yes or no
$Global:ShowDisplayMessage="Yes"
$Global:DisplayMessage="P och G är nu anslutna, du kan avsluta programmet"

#$loggedonuser=$env:USERNAME
$loggedonuser = tasklist /v /FI "IMAGENAME eq explorer.exe" /FO list | find "User Name:"
$loggedonuser = $loggedonuser.Substring(14)
$Global:loggedonuserTask = $loggedonuser
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
        ## When RunAsUser is yes, the three sections below will only execute code in the users context

        ## Execute code for Ulricehamn
        write-console "uhm"
        $Pdrive="\\samkom.se\users\up\" + $loggedonuser
        $Gdrive="\\samkom.se\udata"
        Net use p: $Pdrive /persistent:no
        Net use g: $Gdrive /persistent:no
        
        }
        else {
        ## Execute code for Tranemo
        write-console "tmo"
        $Pdrive="\\samkom.se\users\tp\" + $loggedonuser
        $Gdrive="\\samkom.se\tdata"
        Net use p: $Pdrive /persistent:no
        Net use g: $Gdrive /persistent:no
        
        }
        ## Execute code for everyone
        
                
    }


## ---------------------------------------------------

## Examples

## Powershell does not pause when an exe is executed. Use the following two lines to execute and pause until finished, just duplicate if more then one exe needs to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob

## Working with registry.
# Create a key: New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup' -type Directory -Force -ErrorAction SilentlyContinue
# Edit or create a value: New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup]' -Name 'Prelogon' -Value "1" -PropertyType string -Force -ea SilentlyContinue;
