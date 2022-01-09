$require = $PSScriptRoot + "\require\login.ps1";
. $require

$AzResource = Get-AzResource
if ($AzResource)
{
    try
    {
        $AzResource | Remove-AzResource -Force | out-null
        Write-Host "All Done!`u{1F600}" -ForegroundColor Green
    }
    catch
    {
        Write-Error "Oh no, something went wrong! `u{1F92F}"
    }

}
else
{
    Write-Host "Nothing to clean-up!`u{1F600}" -ForegroundColor Green
}