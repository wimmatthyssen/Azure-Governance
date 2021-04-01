<#

.SYNOPSIS

A script used to deploy a management groups tree structure

.DESCRIPTION

A script used to deploy a management groups tree structure based on the Enterprise-scale architecture for small enterprises.
When all management groups are created the Azure subscriptions will be moved to the corresponding management group.

.NOTES

Filename:       Create_Azure_Management_Groups_Tree_Structure.ps1
Created:        31/07/2020
Last modified:  31/03/2021
Author:         Wim Matthyssen
PowerShell:     PowerShell 5.1; Azure PowerShell
Version:        Install latest Az modules
Action:         Change variables where needed to fit your needs
Disclaimer:     This script is provided "As IS" with no warranties.

.EXAMPLE

.\Create_Azure_Management_Groups_Tree_Structure.ps1

.LINK

#>

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Prerequisites

## Check if running as Administrator, otherwise close the PowerShell window

$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$IsAdministrator = $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($IsAdministrator -eq $false) {
    Write-Host ($writeEmptyLine + "# Please run PowerShell as Administrator" + $writeSeperator + $time)`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
    Start-Sleep -s 5
    exit
}

## Import Azure PowerShell Az module into the PowerShell session

Import-Module Az

##  Suppress Breaking Change Messages

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$customerFullName = "myhcjourney"
$customerName ="myh"

$customerManagementGroupName = "mg-" + $customerFullName 
$customerManagementGroupGuid = New-Guid

$platformManagementGroupName = "mg-" + $customerName + "-platform"
$platformManagementGroupGuid = New-Guid
$landingZonesManagementGroupName = "mg-" + $customerName + "-landingzones"
$landingZonesManagementGroupGuid = New-Guid
$sandboxesManagementGroupName = "mg-" + $customerName + "-sandboxes"
$sandboxesManagementGroupGuid = New-Guid
$decommissionedManagementGroupName = "mg-" + $customerName + "-decommissioned"
$decommissionedManagementGroupGuid = New-Guid

$managemnetManagementGroupName = "mg-" + $customerName + "-management"
$managementManagementGroupGuid = New-Guid
$connectivityManagementGroupName = "mg-" + $customerName + "-connectivity"
$connectivityManagementGroupGuid = New-Guid

$corpManagementGroupName = "mg-" + $customerName + "-corp"
$corpManagementGroupGuid = New-Guid
$onlineManagementGroupName = "mg-" + $customerName + "-online"
$onlineManagementGroupGuid = New-Guid

$writeEmptyLine = "`n"
$writeSeperator = " - "
$writeSpace = " "
$global:currentTime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currentTime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create customer management group

New-AzManagementGroup -GroupId $customerManagementGroupGuid -DisplayName $customerManagementGroupName

$customerParentGroup = Get-AzManagementGroup -GroupId $customerManagementGroupGuid

Write-Host ($writeEmptyLine + "#" + $writeSpace + "Customer management group created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create top management groups (Platform, Landing Zones, Sandboxes, Decommissioned)

New-AzManagementGroup -GroupId $platformManagementGroupGuid -DisplayName $platformManagementGroupName -ParentObject $customerParentGroup
New-AzManagementGroup -GroupId $landingZonesManagementGroupGuid -DisplayName $landingZonesManagementGroupName -ParentObject $customerParentGroup
New-AzManagementGroup -GroupId $sandboxesManagementGroupGuid -DisplayName $sandboxesManagementGroupName -ParentObject $customerParentGroup
New-AzManagementGroup -GroupId $decommissionedManagementGroupGuid -DisplayName $decommissionedManagementGroupName -ParentObject $customerParentGroup

$platformParentGroup = Get-AzManagementGroup -GroupId $platformManagementGroupGuid 
$landingZonesParentGroup = Get-AzManagementGroup -GroupId $landingZonesManagementGroupGuid

Write-Host ($writeEmptyLine + "# Top management groups created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Platform management groups

New-AzManagementGroup -GroupName $managementManagementGroupGuid -DisplayName $managemnetManagementGroupName -ParentObject $platformParentGroup
New-AzManagementGroup -GroupName $connectivityManagementGroupGuid -DisplayName $connectivityManagementGroupName -ParentObject $platformParentGroup

Write-Host ($writeEmptyLine + "# Platform management groups created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Landing Zones management groups

New-AzManagementGroup -GroupName $corpManagementGroupGuid -DisplayName $corpManagementGroupName -ParentObject $landingZonesParentGroup
New-AzManagementGroup -GroupName $onlineManagementGroupGuid -DisplayName $onlineManagementGroupName -ParentObject $landingZonesParentGroup

Write-Host ($writeEmptyLine + "# Landing Zones management groups created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
