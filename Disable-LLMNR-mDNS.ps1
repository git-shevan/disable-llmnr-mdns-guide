# Disable-LLMNR-mDNS.ps1
# Script to create GPOs for disabling LLMNR and mDNS in Active Directory
# Author: AD Security Team
# Version: 1.0

<#
.SYNOPSIS
    Creates Group Policy Objects (GPOs) to disable LLMNR and mDNS in Active Directory.

.DESCRIPTION
    This script automates the creation of Group Policy Objects (GPOs) to disable Link-Local Multicast Name Resolution (LLMNR)
    and Multicast DNS (mDNS) in an Active Directory environment. These protocols can be exploited for man-in-the-middle attacks,
    and disabling them enhances the organization's security posture.

.PARAMETER DCOUPath
    Distinguished name of the Organizational Unit containing Domain Controllers.

.PARAMETER ClientOUPath
    Distinguished name of the Organizational Unit containing client computers.

.EXAMPLE
    .\Disable-LLMNR-mDNS.ps1 -DCOUPath "OU=Domain Controllers,DC=contoso,DC=com" -ClientOUPath "OU=Workstations,DC=contoso,DC=com"

.NOTES
    Requires Group Policy Management module and Domain Administrator privileges.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$DCOUPath,
    
    [Parameter(Mandatory=$true)]
    [string]$ClientOUPath
)

# Check for required permissions and modules
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script needs to be run as Administrator."
    exit 1
}

try {
    Import-Module GroupPolicy -ErrorAction Stop
} catch {
    Write-Error "Group Policy module is required. Please install RSAT tools."
    exit 1
}

function New-LLMNRDisabledGPO {
    param(
        [string]$GPOName = "Disable LLMNR"
    )
    
    try {
        # Create a new GPO for disabling LLMNR
        Write-Host "Creating GPO: $GPOName"
        $GPO = New-GPO -Name $GPOName -Comment "Disables Link-Local Multicast Name Resolution" -ErrorAction Stop
        
        # Set the LLMNR policy to disabled
        Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Type DWord -Value 0 -ErrorAction Stop
        
        Write-Host "Successfully created GPO to disable LLMNR."
        return $GPO
    } catch {
        Write-Error "Failed to create LLMNR GPO: $_"
        return $null
    }
}

function New-MDNSDisabledGPO {
    param(
        [string]$GPOName = "Disable mDNS"
    )
    
    try {
        # Create a new GPO for disabling mDNS
        Write-Host "Creating GPO: $GPOName"
        $GPO = New-GPO -Name $GPOName -Comment "Disables Multicast DNS" -ErrorAction Stop
        
        # Set the mDNS policy registry key
        # The EnableMulticast registry setting with value 0 disables mDNS resolution
        Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Type DWord -Value 0 -ErrorAction Stop
        
        Write-Host "Successfully created GPO to disable mDNS."
        return $GPO
    } catch {
        Write-Error "Failed to create mDNS GPO: $_"
        return $null
    }
}

function Link-GPOToOU {
    param(
        [string]$GPOName,
        [string]$OUPath
    )
    
    try {
        Write-Host "Linking GPO '$GPOName' to OU: $OUPath"
        New-GPLink -Name $GPOName -Target $OUPath -ErrorAction Stop
        Write-Host "Successfully linked GPO to OU."
    } catch {
        Write-Error "Failed to link GPO to OU: $_"
    }
}

# Main script execution
try {
    Write-Host "Creating GPOs for Domain Controllers..."
    $DCGPO_LLMNR = New-LLMNRDisabledGPO -GPOName "DC - Disable LLMNR"
    $DCGPO_mDNS = New-MDNSDisabledGPO -GPOName "DC - Disable mDNS"
    
    Write-Host "Creating GPOs for Client Computers..."
    $ClientGPO_LLMNR = New-LLMNRDisabledGPO -GPOName "Clients - Disable LLMNR"
    $ClientGPO_mDNS = New-MDNSDisabledGPO -GPOName "Clients - Disable mDNS"
    
    # Link GPOs to respective OUs
    if ($DCGPO_LLMNR) { Link-GPOToOU -GPOName $DCGPO_LLMNR.DisplayName -OUPath $DCOUPath }
    if ($DCGPO_mDNS) { Link-GPOToOU -GPOName $DCGPO_mDNS.DisplayName -OUPath $DCOUPath }
    if ($ClientGPO_LLMNR) { Link-GPOToOU -GPOName $ClientGPO_LLMNR.DisplayName -OUPath $ClientOUPath }
    if ($ClientGPO_mDNS) { Link-GPOToOU -GPOName $ClientGPO_mDNS.DisplayName -OUPath $ClientOUPath }
    
    Write-Host -ForegroundColor Green "GPO creation and linking completed successfully."
    Write-Host "Please run 'gpupdate /force' on domain controllers and client computers to apply the new policies."
} catch {
    Write-Error "An error occurred during script execution: $_"
}