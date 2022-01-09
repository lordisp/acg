$require = $PSScriptRoot + "\require\login.ps1";
. $require


$storageAccountName = "acglablordispsa"
$functionAppName = "AcgMyFunctionApp2"


$ResourceGroup = Get-AzResourceGroup
$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroup.ResourceGroupName  -Name $storageAccountName -ErrorAction SilentlyContinue
$functionApp = Get-AzFunctionApp -ResourceGroupName $ResourceGroup.ResourceGroupName -Name $functionAppName


# Storage Account
#
if ($storageAccountName -ne $storageAccount.StorageAccountName)
{
    $storageAccount = New-AzStorageAccount `
    -Name acglablordispsa `
    -ResourceGroupName $ResourceGroup.ResourceGroupName `
    -SkuName Standard_LRS `
    -Location $ResourceGroup.Location
}
Write-Host "Storage Account: $( [char]34 )$( $storageAccount.StorageAccountName )$( [char]34 )"


# FunctionApp
#
if ($functionAppName -ne $functionApp.Name)
{
    $functionApp = New-AzFunctionApp -Name $functionAppName `
    -ResourceGroupName $ResourceGroup.ResourceGroupName `
    -StorageAccount $storageAccount.StorageAccountName `
    -Runtime DotNet `
    -RuntimeVersion 6 `
    -FunctionsVersion 4 `
    -OSType Windows `
    -Location $ResourceGroup.Location
}
Write-Host "Function App: $( [char]34 )$( $functionApp.Name )$( [char]34 )"