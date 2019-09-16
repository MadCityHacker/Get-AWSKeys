# Get-AWSKeys

Get-AWSKeys is a simple PowerShell script that can be used to check a target system (or a list of targets) for potential AWS API credentials. The AWS CLI saves credentials in a file called "credentials" under the ".aws" folder in a user's profile. This script checks for the existence of this file and pulls the contents of it. It also checks for files called "credentials.csv" in common folder locations (Downloads, Documents, and Desktop); when saving newly created access keys, AWS saves the file with this name by default. Alternatively, all CSV files can be pulled from this location. The script logs everything found into a folder saved in the current working directory. **ADMIN privileges are required on target computers to check other user profiles!**

Installation
------------
A PowerShell module (psm1) and PowerShell script (ps1) file have been included. The module file can be imported into PowerShell by running `Import-Module .\Get-AWSKeys.psm1`. Alternatively, the `Get-AWSKeys.ps1` file can be run on-demand.

Parameters
----------
*	**File**: A text file containing a list of target systems
*	**ComputerName**: A single target system to run the script against
*	**AllCSV**: Find all CSVs in the target locations for all systems. By default, the script only pulls back CSVs named credentials.csv

Examples
--------
`Get-AWSKeys.ps1 -ComputerName localhost`
	Check the local system for the existence of the AWS credentials file and CSVs named credentials.csv.

`Get-AWSKeys.ps1 -File Computers.txt -AllCSV`
	Check all computers listed in "Computers.txt" for the existence of the AWS credentials file and all CSVs in each user's Documents, Downloads, and Desktop folders.

Licensing
---------
This program is licensed under GNU GPL v3. For more information, please reference the LICENSE file that came with this program or visit https://www.gnu.org/licenses/.

 Contact Us
 ----------
 Whether you want to report a bug, send a patch, or give some suggestions on this program, please open an issue on the GitHub page or send an email to madcityhacker@gmail.com. Also, be sure to check out my blog at https://madcityhacker.com!