Add-Type -AssemblyName PresentationFramework

# Load global styles
$StylesXaml = Get-Content ".\Styles.xaml" -Raw
$StylesReader = New-Object System.Xml.XmlNodeReader ([xml]$StylesXaml)
$Styles = [Windows.Markup.XamlReader]::Load($StylesReader)

function Set-ControlStyle {
    param(
        $Window,
        $ControlName,
        $StyleName
    )

    $Control = $Window.FindName($ControlName)
    if ($ControlName -eq "CancelButton") {
        $Control.add_click({
            $MainWindow.close()
        })
    }

    if ($ControlName -eq "NextButton") {
        $Control.add_click({
            $MainWindow.close()
            $Window = Show-XamlWindow ".\OptionsWindow1.xaml"
            $Window.ShowDialog()
        })
    }

    if ($ControlName -eq "BackButton") {
        $Control.add_click({
            $MainWindow.close()
            $Window = Show-XamlWindow ".\MainWindow.xaml"
            $Window.ShowDialog()
        })

        # NEED TO ADD GUARD FOR WHAT HAPPENS IF YOU CLICK NEXT WHILE ON THE LAST SLIDE
    }

    $Control.Style = $Window.FindResource($StyleName)
}

# Function to 
function Show-XamlWindow {
    param($XamlPath)

    # Read the XAML file
    $XAML = Get-Content $XamlPath -Raw

    # Create XAML reader
    $WindowReader = New-Object System.Xml.XmlNodeReader ([xml]$XAML)

    # Convert XAML into Window object
    $Window = [Windows.Markup.XamlReader]::Load($WindowReader)
    
    # Add shared styles to this window
    $Window.Resources.MergedDictionaries.Add($Styles)

    Set-ControlStyle $Window "NextButton" "NextButtonStyle"
    Set-ControlStyle $Window "CancelButton" "CancelButtonStyle"
    Set-ControlStyle $Window "BackButton" "BackButtonStyle"
    
    return $window
}

# Load main window
$MainWindow = Show-XamlWindow ".\MainWindow.xaml"

# $Control = $MainWindow.FindName("CancelButton")
# $Control.add_click({
#     $MainWindow.close()
#     $Window = Show-XamlWindow ".\OptionsWindow1.xaml"
#     $Window.ShowDialog()
# })

# Show main window
$MainWindow.ShowDialog()
