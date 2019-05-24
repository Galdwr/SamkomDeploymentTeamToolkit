## Samkom DeploymentTeam Toolkit Template

## By default this script executes commands for the machine and not the user. Se the examples below to execute commands in the users context

## Choose exit behaviour
# reboot, logout or exit
$ExitWay="reboot"

## Display message for the user
# yes or no
$ShowDisplayMessage="yes"
$DisplayMessage="Klicka på knappen nedan och starta om datorn för att slutföra reparationen"

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
New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks' -type Directory -Force -ErrorAction SilentlyContinue
New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect' -type Directory -Force -ErrorAction SilentlyContinue
New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings' -type Directory -Force -ErrorAction SilentlyContinue
New-Item -Path 'HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup]' -type Directory -Force -ErrorAction SilentlyContinue

New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks' -Name 'SetGPCPDefault' -Value "00000001" -PropertyType dword -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\Settings' -Name 'connect-method' -Value "pre-logon" -PropertyType string -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\Settings' -Name 'use-sso' -Value "yes" -PropertyType string -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Palo Alto Networks\PanSetup]' -Name 'Prelogon' -Value "1" -PropertyType string -Force -ea SilentlyContinue;


$GetProcessJob = Start-Job -ScriptBlock {"cmdkey /delete:LegacyGeneric:target=gpcp/LatestCP"}
Wait-Job $GetProcessJob

## ---------------------------------------------------
## Examples

## Powershell does not wait when an exe is executed. Use the following two lines to execute and wait, just duplicate if more then one exe need to be executed
#$GetProcessJob = Start-Job -ScriptBlock {UR COMMAND HERE}
#Wait-Job $GetProcessJob

