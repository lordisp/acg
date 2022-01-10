$require = $PSScriptRoot + "\..\require\login.ps1";
. $require

$ResourceGroup = Get-AzResourceGroup
$template = $PSScriptRoot + '\template\azuredeploy.json'
$parameters = $PSScriptRoot + '\template\parameters.json'

if ($null -eq $deploymentName)
{
    $suffix = Get-Random -Maximum 1000
    $deploymentName = "cosmosdb" + $suffix
}

New-AzResourceGroupDeployment -Name $deploymentName `
-ResourceGroupName $ResourceGroup.ResourceGroupName `
-TemplateFile $template `
-TemplateParameterFile $parameters `
-dbName $deploymentName