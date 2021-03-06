﻿## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="reboot"

## Run script in users context?
# yes or no
$Global:RunAsUser="yes"
# If the script running in users context takes more then 5 seconds to execute, change it below

## Display a message for the user
# yes or no
$Global:ShowDisplayMessage="yes"
$Global:DisplayMessage="Reparationen är klar, klicka på knappen nedan för att starta om datorn"

#$loggedonuser=$env:USERNAME
$Global:loggedonuser = tasklist /v /FI "IMAGENAME eq explorer.exe" /FO list | find "User Name:"
$Global:loggedonuser = $loggedonuser.Substring(14)
$Global:loggedonuser = $loggedonuser -replace '.*?\\(.*)', '$1'

$searcher = [adsisearcher]"(samaccountname=$loggedonuser)"

## Main code for the script/fixes
if ($RunAsUser -eq "yes" -and $RunningFromPowershell -eq "yes") {
    ## If RunAsUSer is yes, this section must be used to execute code for system.
    New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks' -type Directory -Force -ErrorAction SilentlyContinue
    New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect' -type Directory -Force -ErrorAction SilentlyContinue
    New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings' -type Directory -Force -ErrorAction SilentlyContinue
    New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup' -type Directory -Force -ErrorAction SilentlyContinue

    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect' -Name 'SetGPCPDefault' -Value "00000001" -PropertyType dword -Force -ea SilentlyContinue;

    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings' -Name 'connect-method' -Value "pre-logon" -PropertyType string -Force -ea SilentlyContinue;
    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings' -Name 'use-sso' -Value "yes" -PropertyType string -Force -ea SilentlyContinue;

    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup' -Name 'Prelogon' -Value "1" -PropertyType string -Force -ea SilentlyContinue;

    }
    else {
        if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
        {
        ## When RunAsUser is yes, the three sections below will only execute code in the users context
        ## and when RunAsUser is no it executes in the systems context

        ## Execute code for Ulricehamn
        
        
        }
        else {
        ## Execute code for Tranemo
        
        
        }
        ## Execute code for everyone
        start-process cmdkey /delete:LegacyGeneric:target=gpcp/LatestCP -Wait
        
                
    }


## ---------------------------------------------------

## Examples

## Powershell does not pause when an exe is executed. Use the following two lines to execute and pause until finished, just duplicate if more then one exe needs to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob

## Working with registry.
# Create a key: New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup' -type Directory -Force -ErrorAction SilentlyContinue
# Edit or create a value: New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup]' -Name 'Prelogon' -Value "1" -PropertyType string -Force -ea SilentlyContinue;
