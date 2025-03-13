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
# Define the global log file path at the start of the script
$Global:LogFile = "C:\Rsanchezc169ScriptLogs\Log_$(Get-Date -Format 'MM_dd_yyyy_hh_mm_tt').log"

# Global function to handle logging
Function Write-Log {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$Message,                  # The message to log
        [Parameter()]
        [string]$LogFile = $Global:LogFile # Optional: Specify a log file, default to the global log file
    )

    # Ensure the log file exists
    $LogDirectory = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
    }

    # Append the message to the log file with a timestamp
    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $LogFile -Value "$Timestamp : $Message"
}
##################################################################################################################################################################
##################################################################################################################################################################
Function Load-Module {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Modules  # Supports multiple modules
    )

    Foreach ($Module in $Modules) {
        Write-Progress -Activity "Processing Module: $($Module)" -Status "Starting task..." -PercentComplete 0 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        
        Try {
            # Step 1: Check if the module is installed
            Write-Progress -Activity "Processing Module: $($Module)" -Status "Checking installation status..." -PercentComplete 20 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            if ((Get-InstalledModule -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue) -OR (Get-Module -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue)) {
                Write-Warning "Module '$Module' is already installed"
                Write-Log -Message "Module '$Module' is already installed"
            } else {
                Write-Progress -Activity "Processing Module: $($Module)" -Status "Installing module..." -PercentComplete 40 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                Install-Module -Name "$Module*" -Force -Scope CurrentUser -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                Write-Log -Message "Module '$Module' installed successfully"
            }

            # Step 2: Check for updates
            Write-Progress -Activity "Processing Module: $($Module)" -Status "Checking for updates..." -PercentComplete 60 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
            $CurrentVersion = (Find-Module -Name "$Module" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Version
            $InstalledVersion = IF(Get-InstalledModule -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue){(Get-InstalledModule -Name "$Module" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Version} ELSEIF(Get-Module -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue){(Get-Module -Name "$Module" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Version}
            
            if ($CurrentVersion -and $InstalledVersion -and $CurrentVersion -gt $InstalledVersion) {
                Write-Progress -Activity "Processing Module: $($Module)" -Status "Updating module..." -PercentComplete 80 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                Update-Module -Name "$Module" -Force -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                Write-Log -Message "Module '$Module' updated successfully"
            } else {
                Write-Warning "Module '$Module' is up-to-date"
                Write-Log -Message "Module '$Module' is already up to date"
            }

            # Step 3: Import the module
            [ARRAY]$CurrentModules = @()
            IF (Get-InstalledModule -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue) {
                $CurrentModules = (Get-InstalledModule -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Name
            } ELSEIF(Get-Module -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue) {
                $CurrentModules = (Get-Module -Name "$Module*" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue).Name
            }

            if ($CurrentModules) {
                Foreach ($CurrentModule in $CurrentModules) {
                    Write-Progress -Activity "Processing Sub-Module: $($CurrentModule)" -Status "Importing module..." -PercentComplete 90 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                    
                    Try {
                        Import-Module -Name "$CurrentModule" -Force -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
                        Write-Log -Message "Module '$CurrentModule' imported successfully"
                    } Catch {
                        Write-Log -Message "Error importing sub-module '$CurrentModule': $($_.Exception.Message)"
                        Write-Warning "Error importing sub-module '$CurrentModule'. Check logs for details."
                    }
                }
            } else {
                Write-Warning "No modules found matching '$Module'. Ensure the module name is correct."
                Write-Log -Message "No modules found matching '$Module'"
            }
        } Catch {
            # Log any errors
            Write-Log -Message "Error processing module '$Module': $($_.Exception.Message)"
            Write-Warning "Error processing module '$Module'. Check logs for details."
        }
    }

    # Clear the progress bar
    Write-Progress -Activity "Module Processing" -Status "Completed all tasks." -PercentComplete 100 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
    Write-Progress -Activity "Module Processing" -Completed -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
}
##################################################################################################################################################################
#Usage Examples
#Load-Module "PowerShellGet"
#Load-Module "PowerShellGet","Microsoft.Graph"
#Load-Module "PowerShellGet","Microsoft.Graph","MODULE N",.....
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
