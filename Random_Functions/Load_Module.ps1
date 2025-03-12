##################################################################################################################################################################
##################################################################################################################################################################
<#
                 _..--+~/@-~--.
             _-=~      (  .   "}
          _-~     _.--=.\ \""""
        _~      _-       \ \_\
       =      _=          '--'
      '      =                             .
     :      :       ____                   '=_. ___
___  |      ;                            ____ '~--.~.
     ;      ;                               _____  } |
  ___=       \ ___ __     __..-...__           ___/__/__
     :        =_     _.-~~          ~~--.__
_____ \         ~-+-~                   ___~=_______
     ~@#~~ == ...______ __ ___ _--~~--_
                                                    =
██████╗ ███████╗ █████╗ ███╗   ██╗ ██████╗██╗  ██╗███████╗███████╗ ██████╗ ██╗ ██████╗ █████╗ 
██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔════╝██║  ██║██╔════╝╚══███╔╝██╔════╝███║██╔════╝██╔══██╗
██████╔╝███████╗███████║██╔██╗ ██║██║     ███████║█████╗    ███╔╝ ██║     ╚██║███████╗╚██████║
██╔══██╗╚════██║██╔══██║██║╚██╗██║██║     ██╔══██║██╔══╝   ███╔╝  ██║      ██║██╔═══██╗╚═══██║
██║  ██║███████║██║  ██║██║ ╚████║╚██████╗██║  ██║███████╗███████╗╚██████╗ ██║╚██████╔╝█████╔╝
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝ ╚═════╝ ╚════╝ 
Script Version: 1
OS Version Script was written on: Microsoft Windows 11 Pro : 10.0.25100 Build 26100
PSVersion 5.1.26100.2161 : PSEdition Desktop : Build Version 10.0.26100.2161
Description of Script: 
#>
##################################################################################################################################################################
#==============================Beginning of script================================================================================================================
##################################################################################################################################################################
Function Load-Module {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Modules,  # Supports multiple modules
        [Parameter()]
        [string]$LogFile = "C:\EmailExportScriptLogs\ScriptActions.log"  # Default log file path
    )

    # Ensure the directory for the log file exists
    $LogDirectory = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDirectory  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue | Out-Null
    }

    Foreach ($Module in $Modules) {
        Write-Progress -Activity "Processing Module: $($Module)" -Status "Starting task..." -PercentComplete 0

        Try {
            # Step 1: Check if the module is installed
            Write-Progress -Activity "Processing Module: $($Module)" -Status "Checking installation status..." -PercentComplete 20
            if (Get-InstalledModule -Name $Module  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue) {
                Add-Content -Path $LogFile -Value "Module '$Module' is already installed - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            } else {
                Write-Progress -Activity "Processing Module: $($Module)" -Status "Installing module..." -PercentComplete 40
                Install-Module -Name $Module -Repository PSGallery -Force -Scope CurrentUser  -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                Add-Content -Path $LogFile -Value "Module '$Module' installed successfully - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            }

            # Step 2: Check for updates
            Write-Progress -Activity "Processing Module: $($Module)" -Status "Checking for updates..." -PercentComplete 60
            $CurrentVersion = (Find-Module -Name $Module  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Version
            $InstalledVersion = (Get-InstalledModule -Name $Module  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Version
            if ($CurrentVersion -and $InstalledVersion -and $CurrentVersion -gt $InstalledVersion) {
                Write-Progress -Activity "Processing Module: $($Module)" -Status "Updating module..." -PercentComplete 80
                Update-Module -Name $Module -Force  -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                Add-Content -Path $LogFile -Value "Module '$Module' updated successfully - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            } else {
                Add-Content -Path $LogFile -Value "Module '$Module' is already up to date - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            }

            # Step 3: Import the module
            Write-Progress -Activity "Processing Module: $($Module)" -Status "Importing module..." -PercentComplete 90
            Import-Module -Name $Module -Force -Global  -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            Add-Content -Path $LogFile -Value "Module '$Module' imported successfully - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        } Catch {
            # Log any errors
            Add-Content -Path $LogFile -Value "Error processing module '$Module': $($_.Exception.Message) - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"  -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            #Write-Warning "Error processing module '$Module'. Check logs for details."
        }
    }

    # Clear the progress bar
   Write-Progress -Activity "Module Processing" -Status "Completed all tasks." -PercentComplete 100
   Write-Progress -Activity "Module Processing" -Completed

    #Write-Host "All modules processed. Logs available at: $LogFile"
}

#Usage Examples
#Load-Module "PowerShellGet"
#Load-Module "PowerShellGet","Microsoft.Graph"
#Load-Module "PowerShellGet","Microsoft.Graph","MODULE N",.....
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
