function Get-AzureStorageContext{
    [CmdletBinding()]param(
    [Parameter(Mandatory=$true)][string]$storageAccountName,
    [Parameter(Mandatory=$true)][string]$storageAccountKey
    )
    return New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey -Verbose
}

function Get-Files {
    [CmdletBinding()]param(
    [Parameter(Mandatory=$false)][string]$azureRelatedPath,
    [Parameter(Mandatory=$true)][string]$absoluteLocalPath,
    [Parameter(Mandatory=$true)][System.Object]$storageContext
    )

    $items = Get-AzStorageFile -ShareName "<shareName>" -Context $ctx -Path $azureRelatedPath -Verbose | Get-AzStorageFile -Verbose    
    
    foreach($item in $items)
    {
        $item
        $item.Properties      
        #$item.GetType()
        $item.Name + " " + $item.GetType().Name

        if ($item.GetType().Name -eq "CloudFile")
        {
            Write-Host "$(Get-TimeStamp) This is File. Trying to copy..."
            $azureFilePath = Append-Path -basePath $azureRelatedPath -appendix $item.Name
            $destinationFilePath = Append-Path -basePath $absoluteLocalPath -appendix $item.Name
            if(![System.IO.File]::Exists($destinationFilePath)){
                Get-AzStorageFileContent -Path $azureFilePath -ShareName "<shareName>" -Context $ctx -Destination $destinationFilePath -Force -Verbose           
            }            
            Write-Host "Copied"
        }
        else
        {
            Write-Host "This is Folder. Going inside..."
            $azureFilePath = Append-Path -basePath $azureRelatedPath -appendix $item.Name
            $destinationFolderPath = Append-Path -basePath $absoluteLocalPath -appendix $item.Name
            mkdir $destinationFolderPath -Verbose -ErrorAction SilentlyContinue
            Get-Files -azureRelatedPath $azureFilePath -absoluteLocalPath $destinationFolderPath -storageContext $storageContext
        }

    }
}

function Get-File {
    [CmdletBinding()]param(
    [Parameter(Mandatory=$true)][string]$azureFilePath,
    [Parameter(Mandatory=$true)][string]$destinationFolder,
    [Parameter(Mandatory=$true)][System.Object]$storageContext
    )

    $destinationFilePath = Append-Path -basePath $destinationFolder -appendix $azureFilePath
    Get-AzStorageFileContent -Path $azureFilePath -ShareName "<shareName>" -Context $ctx -Destination $destinationFolder -Force -Verbose
    return $destinationFilePath
}