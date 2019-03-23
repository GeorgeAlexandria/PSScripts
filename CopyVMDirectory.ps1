param
(
    [Parameter(Mandatory = $true)]
    [string]$vmName,

    [Parameter(Mandatory = $true)]
    [string]$source,

    [Parameter(Mandatory = $true)]
    [string]$destination
)

function CopyFiles ([string]$sourceFolder, [string]$destinationFolder)
{
    Get-ChildItem -Path $sourceFolder -Force  -File | foreach{
            Write-Output("Copying file: {0}" -f $_.FullName);
            Copy-VMFile $vmName -SourcePath $_.FullName -DestinationPath ("{0}\{1}" -f $destinationFolder, $_.Name) -CreateFullPath -FileSource Host -Force;
        }

    Get-ChildItem -Path $sourceFolder -Force -Directory | foreach{CopyFiles $_.FullName ("{0}\{1}" -f $destinationFolder, $_.Name)}
}

CopyFiles $source $destination