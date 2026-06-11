<#
.SYNOPSIS
    Automates host configuration and telemetry setup for the Detection Engineering Lab.
.DESCRIPTION
    This script configures advanced audit policies, enables PowerShell Script Block
    and Module Logging, downloads/installs Sysmon with a custom configuration, and
    validates the Wazuh Agent service.
.NOTES
    Must be run as Administrator on a Windows 10/11 endpoint.
#>

# Colors for output
$Green = "[+]"
$Yellow = "[-]"
$Red = "[!]"
$Cyan = "[*]"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   Detection Engineering Lab - Setup Automation   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check Administrator Privileges
Write-Host "$Cyan Checking administrative privileges..." -ForegroundColor Cyan
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "$Red CRITICAL ERROR: This script must be run in an elevated PowerShell session." -ForegroundColor Red
    Write-Host "$Red Please right-click PowerShell and select 'Run as Administrator'." -ForegroundColor Red
    Exit 1
}
Write-Host "$Green Elevated privileges confirmed." -ForegroundColor Green

# 2. Configure Windows Advanced Audit Policies
Write-Host ""
Write-Host "$Cyan Configuring Windows Advanced Audit Policies..." -ForegroundColor Cyan

# Enable command-line auditing (includes command line parameters in Event 4688)
$AuditRegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
if (-not (Test-Path $AuditRegPath)) {
    New-Item -Path $AuditRegPath -Force | Out-Null
}
New-ItemProperty -Path $AuditRegPath -Name "ProcessCreationIncludeCmdLine_Enabled" -PropertyType DWORD -Value 1 -Force | Out-Null
Write-Host "$Green Enabled command-line auditing (Process Creation Event ID 4688)." -ForegroundColor Green

# Use auditpol.exe to set audit subcategories
Write-Host "$Cyan Setting audit policies using auditpol..." -ForegroundColor Cyan
try {
    # Process Creation
    auditpol /set /subcategory:"Process Creation" /success:enable | Out-Null
    # Logon (Success & Failure)
    auditpol /set /subcategory:"Logon" /success:enable /failure:enable | Out-Null
    # Account Management
    auditpol /set /subcategory:"User Account Management" /success:enable | Out-Null
    auditpol /set /subcategory:"Security Group Management" /success:enable | Out-Null
    # Service Installation (System security state)
    auditpol /set /subcategory:"Security State Change" /success:enable | Out-Null
    
    Write-Host "$Green Audit policies configured successfully." -ForegroundColor Green
} catch {
    Write-Host "$Red Failed to apply audit policies using auditpol." -ForegroundColor Red
    Write-Warning $_
}

# 3. Enable PowerShell Logging (Script Block & Module Logging)
Write-Host ""
Write-Host "$Cyan Enabling PowerShell telemetry logging..." -ForegroundColor Cyan

$PSRegPath = "HKLM:\Software\Policies\Microsoft\Windows\PowerShell"

# Script Block Logging (Event ID 4104)
$ScriptBlockPath = "$PSRegPath\ScriptBlockLogging"
if (-not (Test-Path $ScriptBlockPath)) {
    New-Item -Path $ScriptBlockPath -Force | Out-Null
}
New-ItemProperty -Path $ScriptBlockPath -Name "EnableScriptBlockLogging" -PropertyType DWORD -Value 1 -Force | Out-Null
New-ItemProperty -Path $ScriptBlockPath -Name "EnableScriptBlockInvocationLogging" -PropertyType DWORD -Value 1 -Force | Out-Null
Write-Host "$Green Enabled PowerShell Script Block Logging (Event 4104)." -ForegroundColor Green

# Module Logging (Event ID 4103)
$ModulePath = "$PSRegPath\ModuleLogging"
if (-not (Test-Path $ModulePath)) {
    New-Item -Path $ModulePath -Force | Out-Null
}
New-ItemProperty -Path $ModulePath -Name "EnableModuleLogging" -PropertyType DWORD -Value 1 -Force | Out-Null

$ModuleNamesPath = "$ModulePath\ModuleNames"
if (-not (Test-Path $ModuleNamesPath)) {
    New-Item -Path $ModuleNamesPath -Force | Out-Null
}
New-ItemProperty -Path $ModuleNamesPath -Name "*" -PropertyType String -Value "*" -Force | Out-Null
Write-Host "$Green Enabled PowerShell Module Logging (Event 4103)." -ForegroundColor Green

# 4. Sysmon Installation & Configuration
Write-Host ""
Write-Host "$Cyan Configuring Microsoft Sysmon..." -ForegroundColor Cyan

$SysmonConfigName = "sysmon-config.xml"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SysmonConfigPath = Join-Path $ScriptDir $SysmonConfigName

if (-not (Test-Path $SysmonConfigPath)) {
    Write-Host "$Yellow Warning: Custom Sysmon configuration file '$SysmonConfigName' not found in script directory." -ForegroundColor Yellow
    Write-Host "$Yellow Sysmon will be installed with default configuration if downloaded." -ForegroundColor Yellow
}

# Check if Sysmon service is already installed
$SysmonService = Get-Service -Name "Sysmon" -ErrorAction SilentlyContinue

if ($SysmonService) {
    Write-Host "$Green Sysmon service is already installed. Updating configuration..." -ForegroundColor Green
    if (Test-Path $SysmonConfigPath) {
        # Update config
        try {
            $SysmonPath = (Get-Command sysmon.exe -ErrorAction SilentlyContinue).Source
            if (-not $SysmonPath) {
                # Fallback to default locations
                $SysmonPath = "C:\Windows\sysmon.exe"
            }
            if (Test-Path $SysmonPath) {
                Start-Process -FilePath $SysmonPath -ArgumentList "-c `"$SysmonConfigPath`"" -Wait -NoNewWindow
                Write-Host "$Green Sysmon configuration updated successfully." -ForegroundColor Green
            } else {
                Write-Host "$Yellow Could not find sysmon.exe path to apply config update." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "$Red Failed to update Sysmon configuration." -ForegroundColor Red
        }
    }
} else {
    Write-Host "$Yellow Sysmon is not installed. Initiating installation process..." -ForegroundColor Yellow
    
    # Create Tools directory
    $ToolsDir = "C:\Tools"
    if (-not (Test-Path $ToolsDir)) {
        New-Item -Path $ToolsDir -ItemType Directory -Force | Out-Null
    }
    
    $ZipPath = Join-Path $ToolsDir "Sysmon.zip"
    $ExtractDir = Join-Path $ToolsDir "Sysmon"
    
    # Download Sysmon from Microsoft Sysinternals
    Write-Host "$Cyan Downloading Sysmon from Sysinternals..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile $ZipPath -UseBasicParsing
        
        Write-Host "$Cyan Extracting Sysmon archive..." -ForegroundColor Cyan
        Expand-Archive -Path $ZipPath -DestinationPath $ExtractDir -Force
        
        $SysmonExe = Join-Path $ExtractDir "Sysmon64.exe"
        if (-not (Test-Path $SysmonExe)) {
            $SysmonExe = Join-Path $ExtractDir "Sysmon.exe"
        }
        
        Write-Host "$Cyan Running Sysmon installation..." -ForegroundColor Cyan
        if (Test-Path $SysmonConfigPath) {
            Start-Process -FilePath $SysmonExe -ArgumentList "-accepteula -i `"$SysmonConfigPath`"" -Wait -NoNewWindow
        } else {
            Start-Process -FilePath $SysmonExe -ArgumentList "-accepteula -i" -Wait -NoNewWindow
        }
        
        # Add C:\Tools\Sysmon to system PATH for easy access
        $CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($CurrentPath -notlike "*$ExtractDir*") {
            [Environment]::SetEnvironmentVariable("Path", $CurrentPath + ";" + $ExtractDir, "Machine")
        }
        
        # Cleanup zip file
        Remove-Item $ZipPath -Force
        
        Write-Host "$Green Sysmon installed and running successfully." -ForegroundColor Green
    } catch {
        Write-Host "$Red Failed to download or install Sysmon automatically." -ForegroundColor Red
        Write-Host "$Red Please install Sysmon manually and apply sysmon-config.xml using: sysmon64.exe -c sysmon-config.xml" -ForegroundColor Red
        Write-Warning $_
    }
}

# 5. Verify Wazuh Agent Status
Write-Host ""
Write-Host "$Cyan Checking Wazuh Agent status..." -ForegroundColor Cyan
$WazuhService = Get-Service -Name "Wazuh" -ErrorAction SilentlyContinue
if (-not $WazuhService) {
    $WazuhService = Get-Service -Name "wazuh-agent" -ErrorAction SilentlyContinue
}

if ($WazuhService) {
    if ($WazuhService.Status -eq 'Running') {
        Write-Host "$Green Wazuh Agent is running." -ForegroundColor Green
    } else {
        Write-Host "$Yellow Wazuh Agent is installed but not running (Status: $($WazuhService.Status))." -ForegroundColor Yellow
        Write-Host "$Cyan Attempting to start Wazuh Agent service..." -ForegroundColor Cyan
        try {
            Start-Service $WazuhService.Name
            Write-Host "$Green Wazuh Agent service started successfully." -ForegroundColor Green
        } catch {
            Write-Host "$Red Failed to start Wazuh Agent service. Please check administrative events." -ForegroundColor Red
        }
    }
} else {
    Write-Host "$Red Wazuh Agent service is not installed on this machine." -ForegroundColor Red
    Write-Host "$Red Please install the Wazuh Agent MSI package to complete log forwarding." -ForegroundColor Red
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "             Lab Configuration Complete           " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Ensure the Wazuh Agent's 'ossec.conf' contains the appropriate paths for"
Write-Host "Microsoft-Windows-Sysmon/Operational and Microsoft-Windows-PowerShell/Operational."
Write-Host ""
