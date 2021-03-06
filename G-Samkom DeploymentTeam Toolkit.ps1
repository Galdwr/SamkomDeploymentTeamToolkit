﻿<# 
    Samkom DeploymentTeam Toolkit
#>

# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$CenterScreen = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$form.StartPosition = $CenterScreen;

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '398,295'
$Form.text                       = "Samkom DeploymentTeam Toolkit"
$Form.BackColor                  = "#4a90e2"
$Form.TopMost                    = $true

$LogoPanel                       = New-Object system.Windows.Forms.Panel
$LogoPanel.height                = 98
$LogoPanel.width                 = 389
$LogoPanel.BackColor             = "#ffffff"
$LogoPanel.location              = New-Object System.Drawing.Point(4,1)

$ExecuteFixButton                = New-Object system.Windows.Forms.Button
$ExecuteFixButton.BackColor      = "#0dc772"
$ExecuteFixButton.text           = "Kör"
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
$RSQButton.text                  = "Avsluta"
$RSQButton.width                 = 100
$RSQButton.height                = 30
$RSQButton.location              = New-Object System.Drawing.Point(280,87)
$RSQButton.Font                  = 'Microsoft Sans Serif,10'
$RSQButton.ForeColor             = ""

$FixGroupbox                     = New-Object system.Windows.Forms.Groupbox
$FixGroupbox.height              = 47
$FixGroupbox.width               = 388
$FixGroupbox.BackColor           = "#e9e9eb"
$FixGroupbox.text                = "Välj åtgärd"
$FixGroupbox.location            = New-Object System.Drawing.Point(4,106)

$StatusListBox                   = New-Object system.Windows.Forms.ListBox
$StatusListBox.text              = "listBox"
$StatusListBox.width             = 373
$StatusListBox.height            = 63
$StatusListBox.location          = New-Object System.Drawing.Point(7,15)

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.text                   = "Samkom DeploymentTeam Toolkit"
$TextBox1.width                  = 210
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(178,20)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'
$TextBox1.Enabled                = $false
$TextBox1.BackColor              = 'white'

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.text                   = "Verktygslåda för att göra livet enklare"
$TextBox2.width                  = 223
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(164,43)
$TextBox2.Font                   = 'Microsoft Sans Serif,10'
$TextBox2.Enabled                = $false
$TextBox2.BackColor              = 'white'

$MadeBy                          = New-Object system.Windows.Forms.TextBox
$MadeBy.multiline                = $false
$MadeBy.text                     = "Programmet skapat av Patrik & Tobias, Johansson"
$MadeBy.BackColor                = "#e9e9eb"
$MadeBy.width                    = 245
$MadeBy.height                   = 20
$MadeBy.location                 = New-Object System.Drawing.Point(10,95)
$MadeBy.Font                     = 'Microsoft Sans Serif,8'
$MadeBy.ForeColor                = "#858383"

$Secret                          = New-Object system.Windows.Forms.textbox
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
$Secret.Add_Click({ Start-Process "https://www.youtube.com/watch?v=dQw4w9WgXcQ" })

function RunButtonClick {
$global:RunningFromPowershell = "yes"
$Global:RunScript = $ImportScriptPath + $ListFixes.SelectedItem

$Working = [scriptblock]::Create("powershell.exe " + $PSScriptRoot + "\working.ps1")
Start-job -Name Working -ScriptBlock $Working
invoke-expression -Command "& '$RunScript'"


if ($RunAsUser -eq "yes"){
    $Global:RunningFromPowershell = "no"
    Copy-Item $RunScript -Destination 'c:\temp' -Recurse -ErrorAction SilentlyContinue
    Stop-ScheduledTask -TaskName SDTT -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName SDTT -Confirm:$false -ErrorAction SilentlyContinue
    $Global:RunScriptTask = "c:\temp\" + $ListFixes.SelectedItem
    $Taskarg = "-hidden -NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -file " + "`"$($RunScriptTask)`"" 
    $action = New-ScheduledTaskAction -Execute "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument $Taskarg
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $Global:loggedonuserTask = $loggedonuser + "@samkom.se"
    $principal = New-ScheduledTaskPrincipal -UserId $loggedonuserTask
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
    Register-ScheduledTask SDTT -InputObject $task
    Start-Job -Name RunTask -ScriptBlock {Start-ScheduledTask -TaskName SDTT}
    Wait-Job -Name RunTask
    Unregister-ScheduledTask -TaskName SDTT -Confirm:$false
}

Stop-job -Name Working
if ($ShowDisplayMessage -eq "yes"){$StatusListBox.items.add($DisplayMessage)}

if ($ExitWay -eq "exit"){$RSQButton.text = "Avsluta"} 
if ($ExitWay -eq "reboot"){$RSQButton.text = "Starta om"} 
if ($ExitWay -eq "logout"){$RSQButton.text = "Logga ut"} 

}

function RSQButtonClick {

if ($ExitWay -eq "exit"){$form.close()} 
if ($ExitWay -eq "reboot"){shutdown /r /t 00} 
if ($ExitWay -eq "logout"){shutdown /l} 

}


#Write your logic code here
$ImagePath = $PSScriptRoot + "\samkom-deployment-team-icon.png"
$LoadingImagePath = $PSScriptRoot + "\ajax-loader.gif"
$Global:ImportScriptPath = $PSScriptRoot + "\scripts\"
$Global:ExitWay = "exit"
# Update scriptfolder
Copy-Item "\\gitgob1.samkom.se\sourcedata\Applications\Available\administrative\G-Samkom DeploymentTeam Toolkit\Scripts\*" -Destination $ImportScriptPath -ErrorAction SilentlyContinue


$AvaliableScripts = Get-ChildItem -path $ImportScriptPath | Select-Object name -ExpandProperty name | ForEach-Object {$listfixes.items.add($_)}


if(!(Test-Path -Path 'c:\temp' )){
    New-Item -ItemType directory -Path 'c:\temp'
}

#Design specifics here
$MadeBy.BorderStyle              = "0"
$TextBox1.BorderStyle            = "0"
$TextBox2.BorderStyle            = "0"
$Secret.Borderstyle           = "0"

[void]$Form.ShowDialog()          