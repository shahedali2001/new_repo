# -------------------------------------------
# Step 1: Login to Azure
# -------------------------------------------
Connect-AzAccount

# -------------------------------------------
# Step 2: Define variables
# -------------------------------------------
$resourceGroup = "MyResourceGroup"
$location = "EastUS"
$storageAccountName = "mystorageaccount2025"  # Must be globally unique & all lowercase
$containerName = "mycontainer"
$localFilePath = "C:\Users\YourName\Documents\myfile.txt"
$blobName = "uploadedfile.txt"
# $resourceGroup = "MyResourceGroup"
# $location = "EastUS"
# $storageAccountName = "mystorageaccount2025"  # Must be globally unique & all lowercase


# New-AzResourceGroup -Name $resourceGroup -Location $location
# -------------------------------------------
# Step 3: Create a Resource Group (if not already created)
# -------------------------------------------
New-AzResourceGroup -Name $resourceGroup -Location $location

# -------------------------------------------
# Step 4: Create Storage Account
# -------------------------------------------
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2

# -------------------------------------------
# Step 5: Get Storage Context
# -------------------------------------------
$ctx = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context

# -------------------------------------------
# Step 6: Create Blob Container
# -------------------------------------------
New-AzStorageContainer -Name $containerName -Context $ctx -Permission Blob

# -------------------------------------------
# Step 7: Upload File to Blob Container
# -------------------------------------------
Set-AzStorageBlobContent -File $localFilePath `
    -Container $containerName `
    -Blob $blobName `
    -Context $ctx

Write-Output "✅ File uploaded successfully to blob container!"
