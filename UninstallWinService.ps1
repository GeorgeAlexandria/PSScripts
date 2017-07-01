param
(
    [string]$serverName,

    [Parameter(Mandatory = $true)]
    [string]$serviceName
)

Write-Output "Checking for existing service..."
if($serverName -eq "")
{
    $service = Get-WmiObject -Namespace "root\cimv2" -Class "Win32_Service" `
        -Filter "Name='$serviceName'" -Impersonation 3
}
else
{
    $service = Get-WmiObject -Namespace "root\cimv2" -Class "Win32_Service" `
        -ComputerName $serverName -Filter "Name='$serviceName'" -Impersonation 3
}

if(!$service)
{
    Write-Warning "Service $serviceName does not found on $serverName. Nothing to uninstall."
    exit 0;
}
Write-Output ($service | Format-List * -Force | Out-String)

if($service.Started)
{
    Write-Output "Stopping service..."

	$opResult = $service.StopService()
    if($opResult.ReturnValue -ne 0)
    {
        Write-Error ("Service does not stop. Return value is {0}.{1}" -f $opResult.ReturnValue, $opResultStr)
        exit 1;
    }
    Write-Output ("Service stopped:{0}" -f $opResultStr)
}

Write-Output "Deleting service..."

$opResult = $service.Delete()
$opResultStr = "{0}{1}" -f [System.Environment]::NewLine, ($opResult | Format-List * -Force | Out-String)
if($opResult.ReturnValue -ne 0)
{
    Write-Error ("Service does not delete. Return value is {0}.{1}" -f $result.ReturnValue, $opResultStr)
    exit 1;
}
Write-Output ("Service deleted:{0}" -f $opResultStr)