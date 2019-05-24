## Samkom DeploymentTeam Toolkit Template

## Choose exit behaviour
# reboot, logout or exit
$Global:ExitWay="exit"

## Display message for the user
# yes or no
$Global:ShowDisplayMessage="yes"
$Global:DisplayMessage="P och G är nu anslutna"

$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
$loggedonuser=$env:USERNAME

## Main code for the fix

if ($searcher.FindOne().Properties.mail -like '*ulricehamn.se*') 
{
## Execute code for Ulricehamn
$Pdrive="\\samkom.se\users\up\" + $loggedonuser
$Gdrive="\\samkom.se\udata"
Net use p: $Pdrive /persistent:no
Net use g: $Gdrive /persistent:no
 }
 else 
{
## Execute code for Tranemo
$Pdrive="\\samkom.se\users\tp\" + $loggedonuser
$Gdrive="\\samkom.se\tdata"
Net use p: $Pdrive /persistent:no
Net use g: $Gdrive /persistent:no
}

## Execute Common code

