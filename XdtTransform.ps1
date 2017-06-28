param
(
    [Parameter(Mandatory = $true)]
	[string]$xmlFile,

    [Parameter(Mandatory = $true)]
	[string]$xdtFile,

    [string]$XmlTransformDllPath
)

if($XmlTransformDllPath -eq "")
{
    Add-Type -AssemblyName "Microsoft.Web.XmlTransform.dll"
}
else
{
    # Add-Type -Path "[LocalDisk]:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v14.0\Web\Microsoft.Web.XmlTransform.dll"
    # Add-Type -Path "[LocalDisk]:\Program Files (x86)\Microsoft Visual Studio\2017\[VSEdition]\MSBuild\Microsoft\VisualStudio\v15.0\Web\Microsoft.Web.XmlTransform.dll"
    Add-Type -Path $XmlTransformDllPath
}

$xml = New-Object System.Xml.XmlDocument
$xml.Load($xmlFile)
$transform = New-Object Microsoft.Web.XmlTransform.XmlTransformation($xdtFile)
$transform.Apply($xml)
$xml.Save($xmlFile)