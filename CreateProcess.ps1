param
(
    [string]$serverName,

    [Parameter(Mandatory = $true)]
    [string]$executionPath,

    [string]$commandLine,
    [string]$currentDirectory
)

# determine server name is local or remote machine
$server = (".", $serverName)[!$serverName -eq $null]

$connection = new-object System.Management.ConnectionOptions
$connection.EnablePrivileges = $true
$connection.Impersonation = "Impersonate"

$scope = new-object System.Management.ManagementScope("\\$server\root\cimv2", $connection)
$scope.Connect()

$managment = new-object System.Management.ManagementClass(
    $scope, 
    (new-object System.Management.ManagementPath("Win32_Process")),
    (new-object System.Management.ObjectGetOptions))

$params = $managment.GetMethodParameters("Create")

$params["CommandLine"] = "$executionPath $commandLine"
$params["CurrentDirectory"] = ((Split-Path -parent $executionPath), $currentDirectory)[!$currentDirectory -eq ""]

$result = $managment.InvokeMethod("Create", $params, $null)    

$strResult = $result | Format-List * -Force | Out-String
if($result.ReturnValue -ne 0)
{
    Write-Error ("Process didn't create. Return value is {0}.{1}{2}" -f $result.ReturnValue, [System.Environment]::NewLine, $strResult)
    exit 1;
}
Write-Output ("Process was created:{0}" -f $strResult)