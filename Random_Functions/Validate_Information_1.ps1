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
Function Validate-Information {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Information,
        [Parameter()]
        [string]$LogFile = "C:\EmailExportScriptLogs\ScriptActions.log"  # Default log file path
    )

    # Ensure the directory for the log file exists
    $LogDirectory = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDirectory -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force -ErrorAction SilentlyContinue | Out-Null
    }

    # Initialize progress bar
    #Write-Progress -Activity "Information Validation" -Status "Starting validation..." -PercentComplete 0

    do {
        #Write-Progress -Activity "Information Validation" -Status "Displaying input information..." -PercentComplete 20
        Write-Host "The value you inputted is: $Information"

        # Ask user for validation
        $Validate = Read-Host -Prompt "The above information was inputted. Is this correct [Y/N]"
        $Validate = $Validate.ToUpper()

        Switch ($Validate) {
            "Y" {
                # Log success and progress
                Add-Content -Path $LogFile -Value "Information validated successfully: $Information - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
                #Write-Progress -Activity "Information Validation" -Status "Validation successful." -PercentComplete 100
                # Clear progress bar
                #Write-Progress -Completed
                return $Information
            }
            "N" {
                # Reset and re-enter information
                #Write-Progress -Activity "Information Validation" -Status "Re-entering information..." -PercentComplete 50
                $Information = Read-Host -Prompt "Enter new value ->"

                # Ensure value is not empty
                while ([string]::IsNullOrWhiteSpace($Information)) {
                    Write-Warning "You did not put in a value. This cannot be empty."
                    $Information = Read-Host -Prompt "Enter new value ->"
                }

                # Log the updated information
                Add-Content -Path $LogFile -Value "Information updated to: $Information - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
            }
            Default {
                # Log invalid validation input
                Add-Content -Path $LogFile -Value "Invalid validation input: $Validate - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
                Write-Warning "Invalid input. Please validate with [Y/N]."
            }
        }
    } while ($Validate -ne "Y")
Clear-Host
}

#Usage
#Validate-Information -Information $Information
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
