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
Function Check-Date {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartDate,  # Enforces datetime input for clarity
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [datetime]$EndDate,    # Enforces datetime input for clarity
        [Parameter()]
        [string]$LogFile = "C:\EmailExportScriptLogs\ScriptActions.log"  # Default log file path
    )
# Ensure the directory for the log file exists
    $LogDirectory = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDirectory -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force -ErrorAction SilentlyContinue | Out-Null
    }
# Initialize progress
    Write-Progress -Activity "Date Validation" -Status "Starting validation..." -PercentComplete 0
try {
        # Step 1: Calculate the timespan
        Write-Progress -Activity "Date Validation" -Status "Calculating time span between dates..." -PercentComplete 30
        $Span = New-TimeSpan -Start $StartDate -End $EndDate
# Step 2: Check if start date is after end date
        if ($Span.TotalSeconds -lt 0) {
            Write-Progress -Activity "Date Validation" -Status "Validation failed: Start date is after end date." -PercentComplete 60
            Add-Content -Path $LogFile -Value "Error: Start date ($StartDate) is after end date ($EndDate) - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
            # Clear progress bar
            Write-Progress  -Activity "Date Validation" -Completed
            return $false
        }
# Step 3: Check if end date is in the future
        Write-Progress -Activity "Date Validation" -Status "Checking if the end date is in the future..." -PercentComplete 80
        if ($EndDate -gt (Get-Date).AddDays(1)) {
            Write-Progress -Activity "Date Validation" -Status "Validation failed: End date is in the future." -PercentComplete 90
            Add-Content -Path $LogFile -Value "Error: End date ($EndDate) is in the future - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
            # Clear progress bar
            Write-Progress  -Activity "Date Validation" -Completed
            return $false
        }
# Validation successful
        Write-Progress -Activity "Date Validation" -Status "Validation successful: Dates are valid." -PercentComplete 100
        Add-Content -Path $LogFile -Value "Success: Start date ($StartDate) and end date ($EndDate) are valid - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
        # Clear progress bar
        Write-Progress  -Activity "Date Validation" -Completed
        return $true
    } catch {
        # Log any unexpected errors
        Write-Progress -Activity "Date Validation" -Status "Validation failed due to an error." -PercentComplete 100
        Add-Content -Path $LogFile -Value "Error during date validation: $($_.Exception.Message) - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
        # Clear progress bar
        Write-Progress  -Activity "Date Validation" -Completed
        throw
    }
    #Clear-Host
}

#Usage
#Check-Date -StartDate "01/10/2025" -EndDate "01/11/2025"
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
