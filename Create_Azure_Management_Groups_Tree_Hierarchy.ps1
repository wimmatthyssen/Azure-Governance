<#

.SYNOPSIS

A script used to deploy a management group tree hierarchy

.DESCRIPTION

A script used to deploy a management group tree hierarchy

.NOTES

Filename:       Create_Azure_Management_Groups_Tree_Hierarchy.ps1
Created:        31/07/2020
Last modified:  31/07/2020
Author:         Wim Matthyssen
PowerShell:     PowerShell 5.1; Azure PowerShell
Version:        Install latest Az modules
Action:         Change variables where needed to fit your needs
Disclaimer:     This script is provided "As IS" with no warranties.

.EXAMPLE

.\Create_Azure_Management_Groups_Tree_Hierarchy.ps1

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

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$customerName ="wma"
$spoke1 = "prd"
$spoke2 = "pre"
$spoke3 = "dev"

$beManagementGroupName = "mg-" + $customerName + "-be"
$beManagementGroupGuid = New-Guid
$usManagementGroupName = "mg-" + $customerName + "-us"
$usManagementGroupGuid = New-Guid

$itBeManagementGroupName = $beManagementGroupName + "-it"
$itBeManagementGroupGuid = New-Guid
$itUsManagementGroupName = $usManagementGroupName + "-it"
$itUsManagementGroupGuid = New-Guid

$spoke1ItBeManagementGroupName = $itBeManagementGroupName + "-" + $spoke1
$spoke1ItBeManagementGroupGuid = New-Guid
$spoke2ItBeManagementGroupName = $itBeManagementGroupName + "-" + $spoke2
$spoke2ItBeManagementGroupGuid = New-Guid
$spoke3ItBeManagementGroupName = $itBeManagementGroupName + "-" + $spoke3
$spoke3ItBeManagementGroupGuid = New-Guid

$spoke1ItUsManagementGroupName = $itUsManagementGroupName + "-" + $spoke1
$spoke1ItUsManagementGroupGuid = New-Guid
$spoke2ItUsManagementGroupName = $itUsManagementGroupName + "-" + $spoke2
$spoke2ItUsManagementGroupGuid = New-Guid
$spoke3ItUsManagementGroupName = $itUsManagementGroupName + "-" + $spoke3
$spoke3ItUsManagementGroupGuid = New-Guid

$global:currentTime = Set-PSBreakpoint -Variable currentTime -Mode Read -Action {Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"
$writeEmptyLine = "`n"
$writeSeperator = " - "

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create country management groups

New-AzManagementGroup -GroupName $beManagementGroupGuid -DisplayName $beManagementGroupName
New-AzManagementGroup -GroupName $usManagementGroupGuid -DisplayName $usManagementGroupName

$beParentGroup = Get-AzManagementGroup -GroupName $beManagementGroupGuid
$usParentGroup = Get-AzManagementGroup -GroupName $usManagementGroupGuid

Write-Host ($writeEmptyLine + "# Country management groups created" + $writeSeperator + $currentTime) -foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create department management groups

New-AzManagementGroup -GroupName $itBeManagementGroupGuid -DisplayName $itBeManagementGroupName -ParentObject $beParentGroup
New-AzManagementGroup -GroupName $itUsManagementGroupGuid -DisplayName $itUsManagementGroupName -ParentObject $UsParentGroup

$beItParentGroup = Get-AzManagementGroup -GroupName $itBeManagementGroupGuid
$usItParentGroup = Get-AzManagementGroup -GroupName $itUsManagementGroupGuid

Write-Host ($writeEmptyLine + "# Department management groups created" + $writeSeperator + $currentTime) -foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create environment management groups

New-AzManagementGroup -GroupName $spoke1ItBeManagementGroupGuid -DisplayName $spoke1ItBeManagementGroupName -ParentObject $beItParentGroup
New-AzManagementGroup -GroupName $spoke2ItBeManagementGroupGuid -DisplayName $spoke2ItBeManagementGroupName -ParentObject $beItParentGroup
New-AzManagementGroup -GroupName $spoke3ItBeManagementGroupGuid -DisplayName $spoke3ItBeManagementGroupName -ParentObject $beItParentGroup

New-AzManagementGroup -GroupName $spoke1ItUsManagementGroupGuid -DisplayName $spoke1ItUsManagementGroupName -ParentObject $usItParentGroup
New-AzManagementGroup -GroupName $spoke2ItUsManagementGroupGuid -DisplayName $spoke2ItUsManagementGroupName -ParentObject $usItParentGroup
New-AzManagementGroup -GroupName $spoke3ItUsManagementGroupGuid -DisplayName $spoke3ItUsManagementGroupName -ParentObject $usItParentGroup

Write-Host ($writeEmptyLine + "# Environment management groups created" + $writeSeperator + $currentTime) -foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------