<#
.SYNOPSIS
    This script scans common locations for AWS API credentials.

.DESCRIPTION
    The purpose of this script is to scan a computer (or list of computers) for potential AWS API credentials. This script checks
    the common location of saved AWS CLI credentials (%USERPROFILE%\.aws\credentials) as well as common file locations (Desktop,
    Documents, Downloads) for any CSV files named credentials.csv. If the -AllCSV switch is used, all CSV files in those locations
    will be pulled.

.NOTES
    Author:    misthi0s (@MadCityHacker)
    Email:     madcityhacker@gmail.com

.LINK
    https://madcityhacker.com

#>

Param (
	[string]$File,
	[string]$ComputerName,
	[switch]$AllCSV = $False
)

function Get-AWSKeys {

	Write-Host -ForegroundColor Green "Get-AWSKeys Script`n"

	If ((!$File) -and (!$ComputerName)) {
		Write-Host -ForegroundColor Red "Must specify a target. Use -File for a list of targets or -ComputerName for a single target."
		Return
	}

    If ($File) {
        $FileExists = Test-Path $File
        If (!$FileExists) {
            Write-Host -ForegroundColor Red "Invalid file. Please specify a file that exists."
            Return
        }
    }
	
	If ($AllCSV -eq $True) {
		$KeyFileCheck = "*.csv"
	} Else {
		$KeyFileCheck = "credentials.csv"
	}
	
	$Date = Get-Date -Format "yyyy-MM-dd-HHmmss"
	New-Item -Path "AWSKeys_$Date" -ItemType Directory | Out-Null

	If ($File) {
		$Hostnames = Get-Content $File
	} Else {
		$Hostnames = @($ComputerName)
	}
	ForEach ($Hostname in $Hostnames) {
		Write-Host -ForegroundColor Cyan "`nComputer: $($Hostname)"
		Try {
			$userFolders = Get-ChildItem -Path "\\$($Hostname)\c$\Users" -ErrorAction Stop
			$LogFile = "AWSKeys_$($Date)\$($Hostname).txt"
			New-Item -Path $LogFile -ItemType File | Out-Null

			Write-Host -ForegroundColor Green "[*] Checking for credentials file"
			ForEach ($folder in $userFolders) {
				$Path = "$($folder.FullName)\.aws\credentials"
				Try {
					$Exists = Test-Path -Path $Path -ErrorAction Stop
				} Catch [System.UnauthorizedAccessException] {
					Write-Warning "[-] Unable to access AWS credentials file for user $($folder) on computer $($Hostname)"
					Continue
				}
				If($Exists -eq "True") {
					Write-Host -ForegroundColor Red "`nUser: $($folder.Name)"
					Add-Content $LogFile "[*] User: $($folder.Name)"
					$creds = Get-Content $Path
					Write-Output $creds
					Add-Content $LogFile "[*] AWS Credentials File:"
					Add-Content $LogFile $creds
                    Add-Content $LogFile "`n"
				}
			}

			Write-Host -ForegroundColor Green "`n[*] Checking for CSVs in Downloads folder"
			ForEach ($folder in $userFolders) {
				$DownloadsFolder = "$($folder.FullName)\Downloads"
				Try {
					$DownloadsExists = Test-Path -Path $DownloadsFolder -ErrorAction Stop
				} Catch [System.UnauthorizedAccessException] {
					Write-Warning "[-] Unable to access Downloads folder for user $($folder) on computer $($Hostname)"
					Continue
				}
				If($DownloadsExists -eq "True") {
					$Downloads = Get-ChildItem -Path $DownloadsFolder -Filter $KeyFileCheck -Recurse -Name
					If($Downloads) {
						Write-Host -ForegroundColor Red "`nUser: $($folder.Name)"
						Write-Output $Downloads
						Add-Content $LogFile "[*] User: $($folder.Name)"
						Add-Content $LogFile "[*] Downloads Folder:"
						Add-Content $LogFile $Downloads
						Add-Content $LogFile "`n"
					}
				}
			}

			Write-Host -ForegroundColor Green "`n[*] Checking for CSVs in Documents folder"
			ForEach ($folder in $userFolders) {
				$DocumentsFolder = "$($folder.FullName)\Documents"
				Try {
					$DocumentsExists = Test-Path -Path $DocumentsFolder -ErrorAction Stop
				} Catch [System.UnauthorizedAccessException] {
					Write-Warning "[-] Unable to access Documents folder for user $($folder) on computer $($Hostname)"
					Continue
				}
				If($DocumentsExists -eq "True") {
					$Documents = Get-ChildItem -Path "$($folder.FullName)\Documents" -Filter $KeyFileCheck -Recurse -Name
					If($Documents) {
						Write-Host -ForegroundColor Red "`nUser: $($folder.Name)"
						Write-Output $Documents
						Add-Content $LogFile "[*] User: $($folder.Name)"
						Add-Content $LogFile "[*] Documents Folder:"
						Add-Content $LogFile $Documents
						Add-Content $LogFile "`n"
					}
				}
			}

			Write-Host -ForegroundColor Green "`n[*] Checking for CSVs in Desktop folder"
			ForEach ($folder in $userFolders) {
				$DesktopFolder = "$($folder.FullName)\Desktop"
				Try {
					$DesktopExists = Test-Path -Path $DesktopFolder -ErrorAction Stop
				} Catch [System.UnauthorizedAccessException] {
					Write-Warning "[-] Unable to access Desktop folder for user $($folder) on computer $($Hostname)"
					Continue
				}
				If($DesktopExists -eq "True") {
					$Desktop = Get-ChildItem -Path "$($folder.FullName)\Desktop" -Filter $KeyFileCheck -Recurse -Name
					If($Desktop) {
						Write-Host -ForegroundColor Red "`nUser: $($folder.Name)"
						Write-Output $Desktop
						Add-Content $LogFile "[*] User: $($folder.Name)"
						Add-Content $LogFile "[*] Desktop Folder:"
						Add-Content $LogFile $Desktop
						Add-Content $LogFile "`n"
					}
				}
			}
		} Catch {
			Write-Host -ForegroundColor Red "[*] Unable to access $($Hostname)."
		}
	}
}

Get-AWSKeys