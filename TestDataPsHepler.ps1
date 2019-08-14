Import-Module $PSScriptRoot\CommonHelpers.ps1 -Verbose -ErrorAction Continue
Import-Module $PSScriptRoot\AzureDataHelper.ps1 -Verbose -ErrorAction Continue

function Get-CommonTestData{
    param(
    [Parameter(Mandatory=$true)][string]$storageAccountName,
    [Parameter(Mandatory=$true)][string]$storageAccountKey,
    [Parameter(Mandatory=$true)][string]$destinationFolder
    )


	Write-Host "I would remove all from" + $destinationFolder + "\*"

    $ctx = Get-AzureStorageContext -storageAccountName $storageAccountName -storageAccountKey $storageAccountKey
	Write-Host $ctx
    Get-Files -azureRelatedPath "\" -absoluteLocalPath $destinationFolder -storageContext $ctx
}

function Get-CommonTestDataArchive{
    [CmdletBinding()]param(
    [Parameter(Mandatory=$true)][string]$storageAccountName,
    [Parameter(Mandatory=$true)][string]$storageAccountKey,
    [Parameter(Mandatory=$true)][string]$azureFilePath,
    [Parameter(Mandatory=$true)][string]$destinationFolder,
	[Parameter(Mandatory=$false)][bool]$keepArchive
    )

    $ctx = Get-AzureStorageContext -storageAccountName $storageAccountName -storageAccountKey $storageAccountKey
    $destinationFilePath = Get-File -azureFilePath $azureFilePath -destinationFolder $destinationFolder -storageContext $ctx
	Unzip -zipfile $destinationFilePath -outpath $destinationFolder

    if ($keepArchive -ne $true){
        Remove-Item -Path $destinationFilePath -Force -Verbose -ErrorAction SilentlyContinue
    }
}

# examples of usage
#Get-CommonTestData -storageAccountName "<accountName>" -storageAccountKey "<accountKey>" -destinationFolder "C:\Temp"
#Get-CommonTestDataArchive -storageAccountName "<accountName>" -storageAccountKey "<accountKey>" -destinationFolde "C:\Temp" -azureFilePath "CommonTestData.zip"