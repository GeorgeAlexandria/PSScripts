[CmdLetBinding(DefaultParameterSetName="Two")]
param
(
    [Parameter(Mandatory = $true)]
	[string]$xsltFile,

    [Parameter(Mandatory = $true)]
	[string]$inputFile,

    [Parameter(Mandatory = $true, ParameterSetName="One")]
	[string]$outputFile,

    [Parameter(Mandatory = $true, ParameterSetName="Two")]
    [string]$outputFormat
)

$item = Get-Item $inputFile

$outputs = @($outputFile, ("{0}\{1}{2}" -f $item.DirectoryName, $item.BaseName, $outputFormat))
$output = $outputs[!($PSCmdlet.ParameterSetName -eq "One")]

$transform = New-Object System.Xml.Xsl.XslCompiledTransform;
$transform.Load($xsltFile)
$transform.Transform($inputFile, $output)