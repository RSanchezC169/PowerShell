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
Function Set-Environment {
    # Initialize progress bar
    Write-Progress -Activity "Environment Setup" -Status "Starting setup..." -PercentComplete 0 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue

    try {
        # Step 1: Clear the console
        Write-Progress -Activity "Environment Setup" -Status "Clearing console..." -PercentComplete 10 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Clear-Host

        # Step 2: Maximize window
        Write-Progress -Activity "Environment Setup" -Status "Maximizing console window..." -PercentComplete 90 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;

            public class User32 {
                [DllImport("user32.dll")]
                public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
            }
"@
        $handle = (Get-Process -ID $PID).MainWindowHandle
        [User32]::ShowWindow($handle, 3)  # Maximize window
        Write-Log -Message "Console window maximized"

        # Step 3: Set execution policy
        Write-Progress -Activity "Environment Setup" -Status "Setting execution policy..." -PercentComplete 20 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Set-ExecutionPolicy -Scope "Process" -ExecutionPolicy "Unrestricted" -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Write-Log -Message "Execution policy set to 'Unrestricted'"

        # Step 4: Load required modules
        Write-Progress -Activity "Environment Setup" -Status "Loading PowerShellGet module..." -PercentComplete 30 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Load-Module -Module "PowerShellGet"
        Write-Log -Message "PowerShellGet module loaded successfully"

        Write-Progress -Activity "Environment Setup" -Status "Loading Microsoft.Graph module..." -PercentComplete 40 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Load-Module -Module "Microsoft.Graph.Authentication", "Microsoft.Graph.Groups", "Microsoft.Graph.Users", "Microsoft.Graph.Mail"
        Write-Log -Message "Microsoft.Graph module loaded successfully"

        # Step 5: Set window properties
        Write-Progress -Activity "Environment Setup" -Status "Configuring console appearance..." -PercentComplete 60 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        $Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'Black')
        $Host.UI.RawUI.ForegroundColor = 'Blue'
        $Host.UI.RawUI.WindowTitle = "Export Emails"
        Write-Log -Message "Console appearance configured: BackgroundColor=Black, ForegroundColor=Blue, WindowTitle='Export Emails'"

        # Step 6: Configure session preferences
        Write-Progress -Activity "Environment Setup" -Status "Setting session preferences..." -PercentComplete 70 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        $Global:FormatEnumerationLimit = -1 
        $Global:ErrorActionPreference = "SilentlyContinue"
        Write-Log -Message "Session preferences configured: FormatEnumerationLimit=-1, ErrorActionPreference=SilentlyContinue"

        # Clear final progress
        Write-Progress -Activity "Environment Setup" -Status "Setup complete." -PercentComplete 100 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Write-Progress -Activity "Environment Setup" -Completed -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Write-Log -Message "Environment setup completed successfully"
    } catch {
        # Handle errors and log them
        Write-Progress -Activity "Environment Setup" -Status "Setup failed due to an error." -PercentComplete 100 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Write-Progress -Activity "Environment Setup" -Completed -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Write-Log -Message "Error during environment setup: $($_.Exception.Message)"
        throw
    }

    Write-Progress -Activity "Environment Setup" -Completed -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue

    # Clean up
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}
##################################################################################################################################################################
#Usage
#Set-Environment
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
