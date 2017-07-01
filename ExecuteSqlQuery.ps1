param
(
    [Parameter(Mandatory = $true)]
    [string]$databaseName,

    [string]$sqlServerName = "(localdb)\.",

    [Parameter(Mandatory = $true)]
    [string]$sqlQuery
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
try
{
    $smoServer = new-object Microsoft.SqlServer.Management.Smo.Server($sqlServerName)
    if(!$smoServer.Databases.Contains($databaseName))
    {
        Write-Error "Database $databaseName does not exist on $sqlServerName"
        exit 1
    }
    $db = $smoServer.Databases[$databaseName]
    $db.ExecuteNonQuery($sqlQuery)
}
catch
{
    Write-Error ($_ | Format-List * -Force | Out-String)
    exit 1
}