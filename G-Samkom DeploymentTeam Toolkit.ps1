<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Samkom DeploymentTeam Toolkit
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '398,295'
$Form.text                       = "Samkom DeploymentTeam Toolkit"
$Form.BackColor                  = "#4a90e2"
$Form.TopMost                    = $false

$LogoPanel                       = New-Object system.Windows.Forms.Panel
$LogoPanel.height                = 98
$LogoPanel.width                 = 389
$LogoPanel.BackColor             = "#ffffff"
$LogoPanel.location              = New-Object System.Drawing.Point(4,1)

$ExecuteFixButton                = New-Object system.Windows.Forms.Button
$ExecuteFixButton.BackColor      = "#0dc772"
$ExecuteFixButton.text           = "Kör vald fix"
$ExecuteFixButton.width          = 100
$ExecuteFixButton.height         = 30
$ExecuteFixButton.location       = New-Object System.Drawing.Point(279,9)
$ExecuteFixButton.Font           = 'Microsoft Sans Serif,10'

$Logo                            = New-Object system.Windows.Forms.PictureBox
$Logo.width                      = 87
$Logo.height                     = 62
$Logo.location                   = New-Object System.Drawing.Point(10,10)
$Logo.imageLocation              = $PSScriptRoot + "\samkom-deployment-team-icon.png"
$Logo.SizeMode                   = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$Listfixes                       = New-Object system.Windows.Forms.ComboBox
$Listfixes.width                 = 262
$Listfixes.height                = 23
$Listfixes.location              = New-Object System.Drawing.Point(7,15)
$Listfixes.Font                  = 'Microsoft Sans Serif,8'

$StatusGroupbox                  = New-Object system.Windows.Forms.Groupbox
$StatusGroupbox.height           = 125
$StatusGroupbox.width            = 388
$StatusGroupbox.BackColor        = "#e9e9eb"
$StatusGroupbox.text             = "Status"
$StatusGroupbox.location         = New-Object System.Drawing.Point(4,160)

$RSQButton                       = New-Object system.Windows.Forms.Button
$RSQButton.BackColor             = "#0dc772"
$RSQButton.text                  = "Åtgärd"
$RSQButton.width                 = 100
$RSQButton.height                = 30
$RSQButton.location              = New-Object System.Drawing.Point(280,87)
$RSQButton.Font                  = 'Microsoft Sans Serif,10'
$RSQButton.ForeColor             = ""

$FixGroupbox                     = New-Object system.Windows.Forms.Groupbox
$FixGroupbox.height              = 47
$FixGroupbox.width               = 388
$FixGroupbox.BackColor           = "#e9e9eb"
$FixGroupbox.text                = "Välj fix"
$FixGroupbox.location            = New-Object System.Drawing.Point(4,106)

$StatusListBox                   = New-Object system.Windows.Forms.ListBox
$StatusListBox.text              = "listBox"
$StatusListBox.width             = 373
$StatusListBox.height            = 63
$StatusListBox.location          = New-Object System.Drawing.Point(7,15)

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.text                   = "Samkom DeploymentTeam Toolkit"
$TextBox1.width                  = 208
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(178,20)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.text                   = "Verktygslåda för att göra livet enklare"
$TextBox2.width                  = 223
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(164,43)
$TextBox2.Font                   = 'Microsoft Sans Serif,10'

$MadeBy                          = New-Object system.Windows.Forms.TextBox
$MadeBy.multiline                = $false
$MadeBy.text                     = "Programmet skapat av Patrik & Tobias, Johansson"
$MadeBy.BackColor                = "#e9e9eb"
$MadeBy.width                    = 245
$MadeBy.height                   = 20
$MadeBy.location                 = New-Object System.Drawing.Point(10,95)
$MadeBy.Font                     = 'Microsoft Sans Serif,8'
$MadeBy.ForeColor                = "#858383"

$Secret                          = New-Object system.Windows.Forms.Button
$Secret.text                     = "π"
$Secret.BackColor                = "#e9e9eb"
$Secret.width                    = 20
$Secret.height                   = 20
$Secret.location                 = New-Object System.Drawing.Point(255,93)
$Secret.Font                     = 'Microsoft Sans Serif,8'
$Secret.ForeColor                = "#858383"

$Form.controls.AddRange(@($LogoPanel,$StatusGroupbox,$FixGroupbox))
$FixGroupbox.controls.AddRange(@($ExecuteFixButton,$Listfixes))
$LogoPanel.controls.AddRange(@($Logo,$TextBox1,$TextBox2))
$StatusGroupbox.controls.AddRange(@($RSQButton,$StatusListBox,$MadeBy,$Secret))

$ExecuteFixButton.Add_Click({ RunButtonClick })
$RSQButton.Add_Click({RSQButtonClick })
$Secret.Add_Click({ Start-Process"https://www.youtube.com/watch?v=dQw4w9WgXcQ" })

function RunButtonClick {
$Logo.ImageLocation = $PSScriptRoot + "\ajax-loader.gif"

$global:RunningFromPowershell = "yes"
$RunScript = $ImportScriptPath + $ListFixes.SelectedItem

$StatusListBox.items.add("Startar.....")

invoke-expression -Command "& '$RunScript'"
# . $RunScript

if ($RunAsUser -eq "yes"){
    write-host "Runasuser executed"
    Stop-ScheduledTask -TaskName SDTT -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName SDTT -Confirm:$false -ErrorAction SilentlyContinue
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-file " + $RunScript
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -UserId $loggedonuserTask
    #(Get-CimInstance –ClassName Win32_ComputerSystem | Select-Object -expand UserName)
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
    Register-ScheduledTask SDTT -InputObject $task
    Start-Job -Name RunTask -ScriptBlock {Start-ScheduledTask -TaskName SDTT}
    Wait-Job -Name RunTask
    #Start-Sleep -Seconds $WaitforTask
    Unregister-ScheduledTask -TaskName SDTT -Confirm:$false
}
$Logo.ImageLocation = $ImagePath

if ($ShowDisplayMessage -eq "yes"){$RSQButton.text = $StatusListBox.items.add($DisplayMessage)}

if ($ExitWay -eq "exit"){$RSQButton.text = "Avsluta"} 
if ($ExitWay -eq "reboot"){$RSQButton.text = "Starta om"} 
if ($ExitWay -eq "logout"){$RSQButton.text = "Logga ut"} 



}

function RSQButtonClick {

if ($ExitWay -eq "exit"){$form.close()} 
if ($ExitWay -eq "reboot"){shutdown /r /t:00} 
if ($ExitWay -eq "logout"){shutdown /l} 

}


#Write your logic code here
$ImagePath = $PSScriptRoot + "\samkom-deployment-team-icon.png"
$LoadingImagePath = $PSScriptRoot + "\ajax-loader.gif"
$ImportScriptPath = $PSScriptRoot + "\scripts\"
$AvaliableScripts = Get-ChildItem -path $ImportScriptPath | Select-Object name -ExpandProperty name | ForEach-Object {$listfixes.items.add($_)}


#Design specifics here
$MadeBy.BorderStyle              = "0"
$TextBox1.BorderStyle            = "0"
$TextBox2.BorderStyle            = "0"
$Secret.FlatAppearance.BorderSize           = "0"

[void]$Form.ShowDialog()          