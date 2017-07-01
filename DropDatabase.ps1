param
(
    [Parameter(Mandatory = $true)]
    [string]$databaseName,

    [string]$sqlServerName = "(localdb)\."
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server($sqlServerName)
if($smoServer.Databases.Contains($databaseName))
{
    $smoServer.KillAllProcess($databaseName)
    $smoServer.KillDatabase($databaseName)
}
