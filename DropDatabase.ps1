param
(
    [Parameter(Mandatory = $true)]
    [string]$databaseName,

    [Parameter(Mandatory = $false)]
    [string]$serverName = "(localdb)\."
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server($serverName)
if($smoServer.Databases.Contains($databaseName))
{
    $smoServer.KillAllProcess($databaseName)
    $smoServer.KillDatabase($databaseName)
}
