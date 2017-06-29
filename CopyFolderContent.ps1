# Copy the source folder child items to destination folder with overwriting
param
(
    [Parameter(Mandatory = $true)]
    [string]$source,

    [Parameter(Mandatory = $true)]
    [string]$destination
)

if(Test-Path $destination)
{
    Get-ChildItem -Path $destination -Force | Where-Object { Test-Path ("{0}\{1}" -f $source, $_.Name) } | Remove-Item -Path {$_.FullName} -Recurse -Force
}

Get-ChildItem -Path $source -Force | Copy-Item -Path {$_.FullName} -Destination {"{0}\{1}" -f $destination, $_.Name} -Recurse -Force