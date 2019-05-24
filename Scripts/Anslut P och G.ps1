## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Display message for the user
# yes or no
$Global:ShowDisplayMessage="yes"
$Global:DisplayMessage="P och G är nu anslutna"

#$loggedonuser=$env:USERNAME
$loggedonuser = tasklist /v /FI "IMAGENAME eq explorer.exe" /FO list | find "User Name:"
$loggedonuser = $loggedonuser.Substring(14)
#$Credential = $loggedonuser
$loggedonuser = $loggedonuser -replace '.*?\\(.*)', '$1'


$searcher = [adsisearcher]"(samaccountname=$loggedonuser)"


## Main code for the fix


if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
{
## Execute code for Ulricehamn
write-host "uhamn"
$GetProcessJob = Start-Job -ScriptBlock {gpupdate.exe}
    #$Pdrive="\\samkom.se\users\up\" + $loggedonuser
    #$Gdrive="\\samkom.se\udata"
    #Net use p: $Pdrive /persistent:no
    #Net use g: $Gdrive /persistent:no

Wait-Job $GetProcessJob


 }
 else 
{
## Execute code for Tranemo
write-host "tmo"
$Pdrive="\\samkom.se\users\tp\" + $loggedonuser
$Gdrive="\\samkom.se\tdata"
Net use p: $Pdrive /persistent:no
Net use g: $Gdrive /persistent:no
}

## Execute Common code

