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
Function Check-Email {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,  # The email address to validate
        [Parameter()]
        [string]$LogFile = "C:\EmailExportScriptLogs\ScriptActions.log"  # Default log file path
    )

    # Ensure the directory for the log file exists
    $LogDirectory = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDirectory -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force -ErrorAction SilentlyContinue | Out-Null
    }

    # Start progress
    #Write-Progress -Activity "Email Validation" -Status "Starting validation..." -PercentComplete 0

    # Define the email validation regex pattern
    $pattern = '^(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\

\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9?\.])+[a-z0-9?]|(?:

\[(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f])+)\]

))$'

    # Validation progress
    #Write-Progress -Activity "Email Validation" -Status "Validating email address format..." -PercentComplete 50

    # Perform email validation
    try {
        if ($EmailAddress -match $pattern) {
            # Log valid email
            Add-Content -Path $LogFile -Value "Valid email address: $EmailAddress - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
            Write-Progress -Activity "Email Validation" -Status "Validation complete: Email is valid." -PercentComplete 100
            # Clear progress bar
            Write-Progress -Activity "Email Validation" -Completed
            return $true
        } else {
            # Log invalid email
            Add-Content -Path $LogFile -Value "Invalid email address: $EmailAddress - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
            Write-Progress -Activity "Email Validation" -Status "Validation complete: Email is invalid." -PercentComplete 100
            # Clear progress bar
            Write-Progress -Activity "Email Validation" -Completed
            return $false
        }
    } catch {
        # Log any unexpected errors
        Add-Content -Path $LogFile -Value "Error validating email address: $($_.Exception.Message) - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
        Write-Progress -Activity "Email Validation" -Status "Validation failed due to an error." -PercentComplete 100
        # Clear progress bar
        Write-Progress -Activity "Email Validation" -Completed
        throw
    }
    #Clear-Host
}

#Usage
#Check-Email -EmailAddress "USER@DOMAIN.COM"
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
