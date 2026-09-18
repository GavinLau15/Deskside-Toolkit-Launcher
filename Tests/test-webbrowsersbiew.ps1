Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Get project root

$ProjectRoot = Split-Path $PSScriptRoot -Parent

function Load-Xaml {
    param([string]$Path)
    
    if (!(Test-Path $Path)) {
        throw "XAML file not found: $Path"
    }
    $xaml = Get-Content $Path -Raw
    [xml]$xml = $xaml
    $reader = New-Object System.Xml.XmlNodeReader $xml
    return [Windows.Markup.XamlReader]::Load($reader)
}

try {
    $View = Load-Xaml (
        Join-Path $ProjectRoot "Views\WebBrowsersView.xaml"
        )
        $TestWindow = New-Object System.Windows.Window
        $TestWindow.Title = "WebBrowsersView Test"
        $TestWindow.Width = 800
        $TestWindow.Height = 600
        $TestWindow.WindowStartupLocation = "CenterScreen"
        $TestWindow.Content = $View
        $TestWindow.ShowDialog()
}
catch {
    Write-Host ""
    Write-Host "VIEW TEST FAILED" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
}