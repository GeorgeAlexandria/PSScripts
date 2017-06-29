param
(
    [Parameter(Mandatory = $true)]
    [string]$share,

    [Parameter(Mandatory = $true)]
    [string]$destination,

    [Parameter(Mandatory = $true)]
    [string]$userName,

    [Parameter(Mandatory = $true)]
    [string]$password
)

try
{
    net use $share $password /USER:$userName
    Copy-Item -Path $share -Destination $destination –Recurse -Force
}
finally
{
    net use $share /delete /y
}
