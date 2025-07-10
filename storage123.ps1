# -------------------------------------------
# Step 1: Login to Azure
# -------------------------------------------
Connect-AzAccount

# -------------------------------------------
# Step 2: Define variables
# -------------------------------------------
$resourceGroup = "shahed-rg"
$location = "EastUS"
$storageAccountName = "shahedstorage1980"   # Must be unique & lowercase
$containerName = "shahed"
$localFilePath = "C:\Users\Avengers\Documents\mahesh1.txt"
$blobName = "uploadedfile.txt"

# -------------------------------------------
# Step 3: Create a Resource Group
# -------------------------------------------
$rg = Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue
if (-not $rg) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}

# -------------------------------------------
# Step 4: Create Storage Account
$storage = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -ErrorAction SilentlyContinue
if (-not $storage) {
    New-AzStorageAccount -ResourceGroupName $resourceGroup `
        -Name $storageAccountName `
        -Location $location `
        -SkuName Standard_LRS `
        -Kind StorageV2

    # Wait until the storage account is ready (few seconds)
    Start-Sleep -Seconds 15
}

# -------------------------------------------
# Step 5: Get Storage Context
$ctx = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context

# -------------------------------------------
# Step 6: Create Blob Container (if not exists)
$container = Get-AzStorageContainer -Name $containerName -Context $ctx -ErrorAction SilentlyContinue
if (-not $container) {
    New-AzStorageContainer -Name $containerName -Context $ctx -Permission Blob
}

# -------------------------------------------
# Step 7: Upload File to Blob
Set-AzStorageBlobContent -File $localFilePath `
    -Container $containerName `
    -Blob $blobName `
    -Context $ctx

Write-Host "✅ File uploaded successfully to Azure Blob Storage!"
