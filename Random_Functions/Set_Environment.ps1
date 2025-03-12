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
Function Set-Environment {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string]$LogFile = "C:\EmailExportScriptLogs\ScriptActions.log"  # Default log file path
    )

    # Ensure the directory for the log file exists
    $LogDirectory = Split-Path -Path $LogFile
    if (-not (Test-Path -Path $LogDirectory -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force -ErrorAction SilentlyContinue | Out-Null
    }

    # Initialize progress bar
    Write-Progress -Activity "Environment Setup" -Status "Starting setup..." -PercentComplete 0

    try {
        # Step 1: Clear the console
        Write-Progress -Activity "Environment Setup" -Status "Clearing console..." -PercentComplete 10
        Clear-Host

        # Step 2: Set execution policy
        Write-Progress -Activity "Environment Setup" -Status "Setting execution policy..." -PercentComplete 20
        Set-ExecutionPolicy -Scope "Process" -ExecutionPolicy "Unrestricted" -Force
        Add-Content -Path $LogFile -Value "Execution policy set to 'Unrestricted' - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"

        # Step 3: Load required modules
        Write-Progress -Activity "Environment Setup" -Status "Loading PowerShellGet module..." -PercentComplete 30
        Load-Module -Module "PowerShellGet"
        Add-Content -Path $LogFile -Value "PowerShellGet module loaded successfully - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"

        Write-Progress -Activity "Environment Setup" -Status "Loading Microsoft.Graph module..." -PercentComplete 40
        Load-Module -Module "Microsoft.Graph"
        Add-Content -Path $LogFile -Value "Microsoft.Graph module loaded successfully - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"

        # Step 4: Set window properties
        Write-Progress -Activity "Environment Setup" -Status "Configuring console appearance..." -PercentComplete 60
        $Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'Black')
        $Host.UI.RawUI.ForegroundColor = 'Blue'
        $Host.UI.RawUI.WindowTitle = "Export Emails"
        Add-Content -Path $LogFile -Value "Console appearance configured: BackgroundColor=Black, ForegroundColor=Blue, WindowTitle='Export Emails' - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"

        # Step 5: Configure session preferences
        Write-Progress -Activity "Environment Setup" -Status "Setting session preferences..." -PercentComplete 70
        $Global:FormatEnumerationLimit = -1 
        $Global:ErrorActionPreference = "SilentlyContinue"
        Add-Content -Path $LogFile -Value "Session preferences configured: FormatEnumerationLimit=-1, ErrorActionPreference=SilentlyContinue - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"

        # Step 6: Maximize window
        Write-Progress -Activity "Environment Setup" -Status "Maximizing console window..." -PercentComplete 90
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
        Add-Content -Path $LogFile -Value "Console window maximized - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"

        # Clear final progress
        Write-Progress -Activity "Environment Setup" -Status "Setup complete." -PercentComplete 100
        Write-Progress -Activity "Environment Setup" -Completed
        Add-Content -Path $LogFile -Value "Environment setup completed successfully - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
    } catch {
        # Handle errors and log them
        Write-Progress -Activity "Environment Setup" -Status "Setup failed due to an error." -PercentComplete 100
        Write-Progress -Activity "Environment Setup" -Completed
        Add-Content -Path $LogFile -Value "Error during environment setup: $($_.Exception.Message) - $((Get-Date).ToString("MM/dd/yyyy hh:mm:ss"))"
        throw
    }

    #Write-Host "Environment setup completed. Logs available at: $LogFile"
    #Clear-Host
}

#Usage
#Set-Environment
##################################################################################################################################################################
#==============================End of Script======================================================================================================================
##################################################################################################################################################################
