# HAVE TO DEAL WITH EXECUTION POLICY< OR RIGHT CLIKC FILE AND THEN SELECT UNBLOCK
# Load web browser URLs from config.json
$configPath = $configPath = Join-Path $PSScriptRoot 'config.json'
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# List of URLs for browser launch configuration
$URLs = @{
    CitrixDirectory = $config.Links.CitrixDirectory
    PowerBICallRouting = $config.Links.PowerBICallRouting
    PowerBISurveys = $config.Links.PowerBISurveys
    M365Copilot = $config.Links.M365Copilot
    OneDrive = $config.Links.OneDrive
    HPWebJetadmin = $config.Links.HPWebJetadmin
    KnowledgeBase = $config.Links.KnowledgeBase
}

# Web browser launch configuration containing browser executables and their startup URLs 
$Browsers = @{
    Edge = @{
        Path = 'MSEdge'
        Urls = @(
            $URLs.Values
        )
    }

    Chrome = @{
        Path = 'Chrome.exe'
        Urls = @(
            $URLs.CitrixDirectory
            $URLs.PowerBICallRouting
            $URLs.PowerBISurveys
            $URLs.M365Copilot
            $URLs.OneDrive
            $URLs.KnowledgeBase
        )
    }
}

# Launch browsers defined in $BrowserConfigs with their corresponding URLs in a new window
$Browsers.Values | ForEach-Object{
    $Arguments = @('--new-window')

    foreach ($Url in $_.Urls) {
        $Arguments += $Url
    }

    Start-Process -FilePath $_.Path -ArgumentList $Arguments
}

# 
$Applications = @{
    Notepad = 'notepad.exe'
    Greenshot = 'greenshot.exe'
    Outlook = ''
    Teams = ''
}

# List of applications to be launched with an admin account
$AdminApplications = @{
    RemoteDesktopConnection = 'mstsc.exe'
    ActiveDirectory = 'dsa.msc'
}

# Use powershell as admin in order to launch specified applications in $AdminApplications with admin credentials.
# $Command is a command string that iterates through $AdminApplication.Values and builds a single semicolon-separated string containing a "Start-Process" command for each application path
$Command = ($AdminApplications.Values | ForEach-Object {
    "Start-Process -FilePath '$_'"
}) -join '; '

##Start-Process 'powershell.exe' -Verb RunAs -ArgumentList $Command

# Open each application 
$Applications.Values | ForEach-Object {
    Write-Host "Opening: '$_'" -ForegroundColor Green
    #Start-Process -FilePath $_
}



# whgen to use simple paths vs just the name, it says simple apps in windows PATh dont need full directories
# perhaps create script to remind u to check for ur tickets for the day?