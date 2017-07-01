[CmdLetBinding(DefaultParameterSetName="None")]
param
(
    [string]$serverName,

    [Parameter(Mandatory = $true)]
    [string]$serviceName,

    [Parameter(Mandatory = $true)]
    [string]$servicePath,

    [int]$serviceType = 0x10,
    [string]$startMode = "Automatic",
    [string]$displayName = $serviceName,
    [string]$description = "",

    [Parameter(Mandatory = $true, ParameterSetName="Cred")]
    [string]$userName = "",

    [Parameter(Mandatory = $true, ParameterSetName="Cred")]
    [string]$password = "",

    [int]$errorControl = 1,

    [string]$loadOrderGroup = "",
    [string[]]$loadOrderGroupDependcies = "",
    [string[]]$dependencies = "",

    [switch]$interactDesktop
)

# determine server name is local or remote machine
$server = (".", $serverName)[!$serverName -eq $null]

$service = Get-WmiObject -Namespace "root\cimv2" -Class "Win32_Service" `
    -ComputerName $server -EnableAllPrivileges -Filter "Name='$serviceName'" -Impersonation 3

if($service)
{
    Write-Warning ("Service {0} exists{1}. Nothing to install" -f $serviceName, (""," on $serverName")[!$serverName -eq $null])
    exit 0;
}

$connection = new-object System.Management.ConnectionOptions
$connection.EnablePrivileges = $true
$connection.Impersonation = "Impersonate"

$scope = new-object System.Management.ManagementScope("\\$server\root\cimv2", $connection)
$scope.Connect()

$managment = new-object System.Management.ManagementClass(
    $scope, 
    (new-object System.Management.ManagementPath("Win32_Service")),
    (new-object System.Management.ObjectGetOptions))

$params = $managment.GetMethodParameters("Create")

$params["Name"] = $serviceName 
$params["DisplayName"] = $displayName
$params["PathName"] = $servicePath
$params["ServiceType"] = $serviceType
$params["ErrorControl"] = $errorControl 
$params["StartMode"] = $startMode
$params["DesktopInteract"] = ($true, $false)[!$interactDesktop]
$params["StartName"] = ($null, $userName)[!$userName -eq ""] 
$params["StartPassword"] = $password
$params["LoadOrderGroup"] = ($null, $loadOrderGroup)[!$loadOrderGroup -eq ""]
$params["LoadOrderGroupDependencies"] = ($null, $loadOrderGroupDependcies)[!$loadOrderGroup -eq ""]
$params["ServiceDependencies"] = ($null, $dependencies)[!$dependencies -eq ""]

Write-Output ("Input parameters:{0}{1}" -f [System.Environment]::NewLine, ($params | Format-List * -Force | Out-String))

Write-Output "Creating service..."
$result = $managment.InvokeMethod("Create", $params, $null)    

$strResult = $result | Format-List * -Force | Out-String
if($result.ReturnValue -ne 0)
{
    Write-Error ("Service didn't install. Return value is {0}.{1}{2}" -f $result.ReturnValue, [System.Environment]::NewLine, $strResult)
    exit 1;
}
Write-Output ("Service was created:{0}" -f $strResult)
        
$repeatCount = 5
do {
    Start-Sleep -Seconds 2
    Write-Output "Checking service state..."

    $service = Get-WmiObject -Namespace "root\cimv2" -Class "Win32_Service" `
        -ComputerName $server -EnableAllPrivileges -Filter "Name='$serviceName'" -Impersonation 3 
} while(!$service -and --$repeatCount -gt 0)

if(!$service)
{
    Write-Error "Service wasn't installed at there moment."
    exit 1;
}

Write-Output ($service | Format-List * -Force | Out-String)

if (!($service.Started))
{
    Write-Output "Starting service $serviceName on server $serverName..."

    $result = $service.StartService()
    $strResult = $result | Format-List * -Force | Out-String

    if($result.ReturnValue -ne 0)
    {
        Write-Error ("Service didn't start. Return values is {0}.{1}{2}" -f $result.ReturnValue, [System.Environment]::NewLine, $strResult)
        exit 1;
    }
    Write-Output ("Service was started: {0}" -f $strResult)
}

$repeatCount = 5
do {
    Start-Sleep -Seconds 2
    Write-Output "Checking service state..."

    $service = Get-WmiObject -Namespace "root\cimv2" -Class "Win32_Service" `
        -ComputerName $server -EnableAllPrivileges -Filter "Name='$serviceName'" -Impersonation 3 
} while(!$service.Started -and --$repeatCount -gt 0)

if(!$service.Started)
{
    Write-Error "Service wasn't started at there moment."
    exit 1;
}