$require = $PSScriptRoot + "\..\require\login.ps1";
. $require

# replace the trigger url from MyDurableFunctionsHttpStart

$startUrl = "https://fa-t7e4vix4x7rma.azurewebsites.net/api/orchestrators/MyDurableFunctionsOrchestrator?code=VdkOmdjmk2ruNxkeDRqtdIsQtYgEXi7ze82AQCKJ9NU87qvfPiYtug=="

$r = Invoke-WebRequest -Uri $startUrl

$response = ConvertFrom-Json $r.Content

$s = Invoke-WebRequest -Uri $response.statusQueryGetUri

$status = ConvertFrom-Json $s.Content

$status.output