function Get-TimeStamp {    
    return "[{0:dd/MM/yy} {0:HH:mm:ss.fff}]" -f (Get-Date)    
}

function Append-Path {    
    [CmdletBinding()]param(
    [Parameter(Mandatory=$false)][string]$basePath,
    [Parameter(Mandatory=$false)][string]$appendix
    )
    if ($basePath -eq "") {
        return $appendix
    } elseif ($appendix -eq "") {
        return $basePath
    } else {
        return $basePath + "\" + $appendix
    }
}

function Unzip {
    param([string]$zipfile, [string]$outpath)
	Expand-Archive -Path $zipfile -DestinationPath $outpath -Force
}