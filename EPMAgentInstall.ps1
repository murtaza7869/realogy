# Define the file and folder paths
$filePath = "C:\Windows\Temp\PimaOfflineData\Artifacts\SelfContainedEpmAgentInstall_Setup"  # Change this to the path of your file
$expectedExtension = ".zip"
$extractedFolderPath = [System.IO.Path]::Combine((Get-Item $filePath).DirectoryName, "extracted")
$msiFileName = "SelfcontainedEpmagentinstall.msi"  # Change this to the name of your MSI file

# Step 1: Add the missing extension if necessary
if (-not $filePath.EndsWith($expectedExtension)) {
    $filePathWithExtension = "$filePath$expectedExtension"
    Rename-Item -Path $filePath -NewName $filePathWithExtension
    Write-Output "Renamed file to $filePathWithExtension"
} else {
    $filePathWithExtension = $filePath
    Write-Output "File already has the extension: $filePathWithExtension"
}

# Step 2: Extract the ZIP file
if (-not (Test-Path $extractedFolderPath)) {
    New-Item -Path $extractedFolderPath -ItemType Directory
    Write-Output "Created directory: $extractedFolderPath"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($filePathWithExtension, $extractedFolderPath)
Write-Output "Extracted $filePathWithExtension to $extractedFolderPath"

# Step 3: Run the MSI installer silently
$msiFilePath = [System.IO.Path]::Combine($extractedFolderPath, $msiFileName)
Write-Output "MSI file path: $msiFilePath"

Start-Process msiexec.exe -ArgumentList "/i `"$msiFilePath`" /quiet /norestart" -NoNewWindow -Wait
Write-Output "Installation completed."

# Optionally, write all output to a file
Write-Output "Renamed file to $filePathWithExtension" | Out-File -FilePath "C:\Windows\temp\EPMagentInstalllog.txt" -Append
Write-Output "Created directory: $extractedFolderPath" | Out-File -FilePath "C:\Windows\temp\EPMagentInstalllog.txt" -Append
Write-Output "Extracted $filePathWithExtension to $extractedFolderPath" | Out-File -FilePath "C:\Windows\temp\EPMagentInstalllog.txt" -Append
Write-Output "MSI file path: $msiFilePath" | Out-File -FilePath "C:\Windows\temp\EPMagentInstalllog.txt" -Append
Write-Output "Installation completed." | Out-File -FilePath "C:\Windows\temp\EPMagentInstalllog.txt" -Append
