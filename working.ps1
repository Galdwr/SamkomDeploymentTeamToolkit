<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
$CenterScreen = [System.Windows.Forms.FormStartPosition]::CenterScreen;

[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '398,295'
$Form.TopMost                    = $false
$FormImage = [system.drawing.image]::FromFile($PSScriptRoot + "\background1.png")
$Form.BackgroundImage = $FormImage
$form.StartPosition = $CenterScreen;
#s$form.ControlBox = $false
$Form.TopMost                    = $true

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 150
$PictureBox1.height              = 150
$PictureBox1.location            = New-Object System.Drawing.Point(123,106)
$PictureBox1.imageLocation       = $PSScriptRoot + "\ajax-loader.gif"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$PictureBox1.Backg
$PictureBox1.BackColor           = 'transparent'

$Form.controls.AddRange(@($PictureBox1))




#Write your logic code here

[void]$Form.ShowDialog()