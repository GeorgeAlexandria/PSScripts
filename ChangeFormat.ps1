param
(
    [Parameter(Mandatory = $true)]
    [string]$sourcePath,

    [Parameter(Mandatory = $true)]
    [string]$format,

    [string]$destinationPath,
    [string[]]$includeSourceFormats,
    [string[]]$excludeSourceFormats
)

$dstPath = ($sourcePath, $destinationPath)[!$destinationPath -eq ""]

$inFormats = (($includeSourceFormats | foreach {"*.{0}" -f $_}), @())[!$includeSourceFormats.Length -gt 0]
$exFormats = (($excludeSourceFormats | foreach {"*.{0}" -f $_}), @())[!$includeSourceFormats.Length -gt 0]

Get-ChildItem -Path $sourcePath -Recurse -File -Include $inFormats -Exclude $exFormats |
    Move-Item -Destination {"{0}\{1}.{2}" -f $dstPath, $_.BaseName, $format}