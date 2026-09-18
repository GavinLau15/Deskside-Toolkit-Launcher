Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# the controller of the application. it manages navigation, loading views and saving data

$ScriptRoot = $PSScriptRoot
Write-Host "Script Root: $ScriptRoot"

# Function to load a XAML file, it returns an actual WPF object
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

# this function does all the heavy lifting, when called it looks at your current index (ex. 0), loads (adminappsview.xaml)
# and places it inside maincontent
# $Maincontent.content = $view
# now the user sees the page
function Show-CurrentView {

    $view = Load-Xaml $script:Views[$script:CurrentIndex]
    
    $script:CurrentView = $view
    
    $MainContent.Content = $view
    
    $BackButton.IsEnabled = ($script:CurrentIndex -gt 0)
    
    if ($script:CurrentIndex -eq ($script:Views.Count - 1)) {
        $NextButton.Content = "Finish"
    }
    
    else {
        $NextButton.Content = "Next"
    }
    
    Update-StepLabel
}

function Update-StepLabel {
    $StepLabel.Content =
    "Step $($script:CurrentIndex + 1) of $($script:Views.Count)"
}

function Save-CurrentViewData {

    switch ($script:CurrentIndex) {

    # ============================================================
    # Admin Apps
    # ============================================================

        0 {
            $script:ProfileConfig.AdminApps = @()

            $cbADUC = $script:CurrentView.FindName("cbADUC")
            $cbMECM = $script:CurrentView.FindName("cbMECM")

            if ($cbADUC.IsChecked) {
                $script:ProfileConfig.AdminApps += "Active Directory"

            }
        
            if ($cbMECM.IsChecked) {
                $script:ProfileConfig.AdminApps += "MECM"

            }

        }

        # ============================================================
        # Regular Apps
        # ============================================================

        1 {

            $script:ProfileConfig.Applications = @()

            $cbOutlook = $script:CurrentView.FindName("cbOutlook")
            $cbTeams = $script:CurrentView.FindName("cbTeams")

            if ($cbOutlook.IsChecked) {
                $script:ProfileConfig.Applications += "Outlook"
            }

            if ($cbTeams.IsChecked) {
                $script:ProfileConfig.Applications += "Teams"
            }

        }

        # ============================================================
        # URLs
        # ============================================================

        2 {

            $script:ProfileConfig.URLs = @()

            $cbServiceNow = $script:CurrentView.FindName("cbServiceNow")
            $cbSharePoint = $script:CurrentView.FindName("cbSharePoint")

            if ($cbServiceNow.IsChecked) {
                $script:ProfileConfig.URLs += "ServiceNow"
            }

            if ($cbSharePoint.IsChecked) {
                $script:ProfileConfig.URLs += "SharePoint"
            }

        }
        # ============================================================
        # Summary
        # ============================================================

        3 {
        
            Write-Host "Wizard completed"
 
            $script:ProfileConfig | Format-List
        }
    }
}



# =====================================================================
# SHARED DATA
# =====================================================================

$script:ProfileConfig = [PSCustomObject]@{
    AdminApps = @()
    Applications = @()
    URLs = @()

}

# =====================================================================
# VIEW ORDER
# =====================================================================

# views array. think of it as page 1, 2, 3, 4
$script:Views = @(
    (Join-Path $ScriptRoot "Views\AdminAppsView.xaml"),
    (Join-Path $ScriptRoot "Views\RegularAppsView.xaml"),
    (Join-Path $ScriptRoot "Views\UrlsView.xaml"),
    (Join-Path $ScriptRoot "Views\SummaryView.xaml")
)

# Current Index is used to track where the user i
#0 = Admin Apps

#1 = Regular Apps

#2 = URLs

#3 = Summary
$script:CurrentIndex = 0
$script:CurrentView = $null

# =====================================================================
# LOAD MAIN WINDOW
# =====================================================================

$MainWindow = Load-Xaml (Join-Path $ScriptRoot "MainWindow.xaml") 

if (-not $MainWindow) {
    throw "MainWindow failed to load."
    }

$MainContent = $MainWindow.FindName("MainContent")
$BackButton = $MainWindow.FindName("BackButton")
$NextButton = $MainWindow.FindName("NextButton")
$StepLabel = $MainWindow.FindName("StepLabel")

# =====================================================================
# BUTTON EVENTS
# =====================================================================

$BackButton.Add_Click({
    if ($script:CurrentIndex -gt 0) {
        $script:CurrentIndex--
        Show-CurrentView
    }
})

$NextButton.Add_Click({
    Save-CurrentViewData

    if ($script:CurrentIndex -eq ($script:Views.Count - 1)) {
        $script:ProfileConfig | Format-List
        $MainWindow.Close()
        return
    }
    $script:CurrentIndex++

    Show-CurrentView
})

# =====================================================================
# START WIZARD
# =====================================================================

Show-CurrentView

$MainWindow.ShowDialog()

Write-Host "Script Root: $ScriptRoot"
Write-Host "Loading: $ScriptRoot\MainWindow.xaml"


# $MainWindow = Load-Xaml ".\MainWindow.xaml"



# $MainContent = $MainWindow.FindName("MainContent")

# $BackButton = $MainWindow.FindName("BackButton")

# $NextButton = $MainWindow.FindName("NextButton")

# # Load global styles
# $StylesXaml = Get-Content ".\Styles.xaml" -Raw
# $StylesReader = New-Object System.Xml.XmlNodeReader ([xml]$StylesXaml)
# $Styles = [Windows.Markup.XamlReader]::Load($StylesReader)

# function Set-ControlStyle {
#     param(
#         $Window,
#         $ControlName,
#         $StyleName
#     )

#     $Control = $Window.FindName($ControlName)
#     if ($ControlName -eq "CancelButton") {
#         $Control.add_click({
#             $MainWindow.close()
#         })
#     }

#     if ($ControlName -eq "NextButton") {
#         $Control.add_click({
#             $MainWindow.close()
#             $Window = Show-XamlWindow ".\RegularApps.xaml"
#             $Window.ShowDialog()
#         })
#     }

#     if ($ControlName -eq "BackButton") {
#         $Control.add_click({
#             $MainWindow.close()
#             $Window = Show-XamlWindow ".\MainWindow.xaml"
#             $Window.ShowDialog()
#         })

#         # NEED TO ADD GUARD FOR WHAT HAPPENS IF YOU CLICK NEXT WHILE ON THE LAST SLIDE
#     }

#     $Control.Style = $Window.FindResource($StyleName)
# }

# # Function to 
# function Show-XamlWindow {
#     param($XamlPath)

#     # Read the XAML file
#     $XAML = Get-Content $XamlPath -Raw

#     # Create XAML reader
#     $WindowReader = New-Object System.Xml.XmlNodeReader ([xml]$XAML)

#     # Convert XAML into Window object
#     $Window = [Windows.Markup.XamlReader]::Load($WindowReader)
    
#     # Add shared styles to this window
#     $Window.Resources.MergedDictionaries.Add($Styles)

#     Set-ControlStyle $Window "NextButton" "NextButtonStyle"
#     Set-ControlStyle $Window "CancelButton" "CancelButtonStyle"
#     Set-ControlStyle $Window "BackButton" "BackButtonStyle"
    
#     return $window
# }

# # Load main window
# $MainWindow = Show-XamlWindow ".\MainWindow.xaml"

# # $Control = $MainWindow.FindName("CancelButton")
# # $Control.add_click({
# #     $MainWindow.close()
# #     $Window = Show-XamlWindow ".\OptionsWindow1.xaml"
# #     $Window.ShowDialog()
# # })

# # Show main window
# $MainWindow.ShowDialog()
