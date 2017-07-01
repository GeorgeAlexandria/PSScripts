[CmdLetBinding(DefaultParameterSetName="File")]
param
(
    [Parameter(Mandatory = $true)]
    [string]$databaseName,

    [string]$sqlServerName = "(localdb)\.",

    [Parameter(Mandatory = $true, ParameterSetName="Query")]
    [string]$sqlQuery,

    [Parameter(Mandatory = $true, ParameterSetName="File")]
    [string]$sqlFilePath
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
    $query = (((Get-Content $sqlFilePath) -join [Environment]::NewLine), $sqlQuery)[!$PSCmdlet.ParameterSetName -eq "File"]

    $db = $smoServer.Databases[$databaseName]
    $db.ExecuteNonQuery($query)
}
catch
{
    Write-Error ($_ | Format-List * -Force | Out-String)
    exit 1
}