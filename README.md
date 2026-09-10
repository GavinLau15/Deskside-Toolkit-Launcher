# Deskside Toolkit Launcher

A PowerShell script that automates the startup routine for Deskside Support Analysts, launching commonly used applications and web resources with a single command and one UAC prompt.

## Requirements
 
  - Windows 10/11
  - Powershell 5.1 or later
  - Local administrator rights (for admin tools)

## Instructions
 1. Clone or download the repository (https://github.com/GavinLau15/Deskside-Toolkit-Launcher.git).
 2. Unblock the file by one of the following methods:
    a. Right click LaunchApplications.ps1 -> Select Properties -> Select Unblock -> Click Apply
    b. Open powershell and navigate to the folder, and then run: Unblock-File .\LaunchApplications.ps1
 2. Update the application paths in LaunchApplications.ps1 as needed to suit your preferences.
 3. Right click LaunchApplications.ps1 and select **Run with PowerShell**
 4. Approve the UAC prompt for administrative applications. 

## Future Functionality
 - Detect installed applications and determine which tools are available.
 - Detect AD group memberships to identify application access and permissions.
 - Install missing applications automatically.
 - Provide a configuration menu for selecting applications, browser preferences, and web resources.
 - Store user preferences in a configurable settings file.