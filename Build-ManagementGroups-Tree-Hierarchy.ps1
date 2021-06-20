<#
.SYNOPSIS

A script used to build a management groups tree structure

.DESCRIPTION

A script used to build a management groups tree structure based on the Enterprise-scale architecture with hub and spoke architecture.

.NOTES

Filename:       Build-ManagementGroups-Tree-Hierarchy.ps1
Created:        31/07/2020
Last modified:  20/06/2021
Author:         Wim Matthyssen
PowerShell:     Azure Cloud Shell or Azure PowerShell
Version:        Install latest Azure Powershell modules
Action:         Change variables were needed to fit your needs. 
Disclaimer:     This script is provided "As IS" with no warranties.

.EXAMPLE

Build-ManagementGroups-Tree-Hierarchy.ps1

.LINK

https://wmatthyssen.com/2020/08/01/azure-powershell-script-create-a-management-group-tree-hierarchy/
#>

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$customerFullName = "myhcjourney"
$customerShortName ="myh"

$customerManagementGroupName = "mg-" + $customerFullName 
$customerManagementGroupGuid = New-Guid

$platformManagementGroupName = "mg-" + $customerShortName + "-platform"
$platformManagementGroupGuid = New-Guid
$landingZonesManagementGroupName = "mg-" + $customerShortName + "-landingzones"
$landingZonesManagementGroupGuid = New-Guid
$sandboxesManagementGroupName = "mg-" + $customerShortName + "-sandboxes"
$sandboxesManagementGroupGuid = New-Guid
$decommissionedManagementGroupName = "mg-" + $customerShortName + "-decommissioned"
$decommissionedManagementGroupGuid = New-Guid

$managementManagementGroupName = "mg-" + $customerShortName + "-management"
$managementManagementGroupGuid = New-Guid
$connectivityManagementGroupName = "mg-" + $customerShortName + "-connectivity"
$connectivityManagementGroupGuid = New-Guid
$identityManagementGroupName = "mg-" + $customerShortName + "-identity"
$identityManagementGroupGuid = New-Guid

$corpManagementGroupName = "mg-" + $customerShortName + "-corp"
$corpManagementGroupGuid = New-Guid
$onlineManagementGroupName = "mg-" + $customerShortName + "-online"
$onlineManagementGroupGuid = New-Guid
$sapManagementGroupName = "mg-" + $customerShortName + "-sap"
$sapManagementGroupGuid = New-Guid

$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperator = "-"
$writeSeperatorSpaces = " - "

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Prerequisites

## Check if running as Administrator (when not running from Cloud Shell), otherwise close the PowerShell window

if ($PSVersionTable.Platform -eq "Unix") {
    Write-Host ($writeEmptyLine + "# Running in Cloud Shell" + $writeSeperatorSpaces + $currentTime)
} else {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdministrator -eq $false) {
    Write-Host ($writeEmptyLine + "# Please run PowerShell as Administrator" + $writeSeperatorSpaces + $currentTime +$writeEmptyLine)`
    -foregroundcolor $foregroundColor1
        Start-Sleep -s 4
    exit} else {
        ## Import Az module into the PowerShell session
        Import-Module Az
        Write-Host ($writeEmptyLine + "# Az module imported" + $writeSeperatorSpaces + $currentTime)`
        -foregroundcolor $foregroundColor1 $writeEmptyLine
    }
}

## Suppress breaking change warning messages

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Deployment started

Write-Host ($writeEmptyLine + "# Deployment started" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create customer (or company) management group

New-AzManagementGroup -GroupId $customerManagementGroupGuid -DisplayName $customerManagementGroupName

$customerParentGroup = Get-AzManagementGroup -GroupId $customerManagementGroupGuid

Write-Host ($writeEmptyLine + "# Customer management group created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create top management groups (Platform, Landing Zones, Sandboxes, Decommissioned)

New-AzManagementGroup -GroupId $platformManagementGroupGuid -DisplayName $platformManagementGroupName -ParentObject $customerParentGroup
New-AzManagementGroup -GroupId $landingZonesManagementGroupGuid -DisplayName $landingZonesManagementGroupName -ParentObject $customerParentGroup
New-AzManagementGroup -GroupId $sandboxesManagementGroupGuid -DisplayName $sandboxesManagementGroupName -ParentObject $customerParentGroup
New-AzManagementGroup -GroupId $decommissionedManagementGroupGuid -DisplayName $decommissionedManagementGroupName -ParentObject $customerParentGroup

$platformParentGroup = Get-AzManagementGroup -GroupId $platformManagementGroupGuid 
$landingZonesParentGroup = Get-AzManagementGroup -GroupId $landingZonesManagementGroupGuid

Write-Host ($writeEmptyLine + "# Top management groups created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Platform management groups

New-AzManagementGroup -GroupName $managementManagementGroupGuid -DisplayName $managementManagementGroupName -ParentObject $platformParentGroup
New-AzManagementGroup -GroupName $connectivityManagementGroupGuid -DisplayName $connectivityManagementGroupName -ParentObject $platformParentGroup
New-AzManagementGroup -GroupName $identityManagementGroupGuid -DisplayName $identityManagementGroupName -ParentObject $platformParentGroup

Write-Host ($writeEmptyLine + "# Platform management groups created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Landing Zones management groups

New-AzManagementGroup -GroupName $corpManagementGroupGuid -DisplayName $corpManagementGroupName -ParentObject $landingZonesParentGroup
New-AzManagementGroup -GroupName $onlineManagementGroupGuid -DisplayName $onlineManagementGroupName -ParentObject $landingZonesParentGroup
New-AzManagementGroup -GroupName $sapManagementGroupGuid -DisplayName $sapManagementGroupName -ParentObject $landingZonesParentGroup

Write-Host ($writeEmptyLine + "# Landing Zones management groups created" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
