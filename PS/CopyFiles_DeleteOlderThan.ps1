# ==============================
# CONFIGURATION
# ==============================
$LocalPath = "D:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\BAK"       # Local source folder
$UNCPath   = "\\N-ashnacifs1\sqldumps$\M-Meopsmgr\Bak"       # Destination UNC path
$Days      = 10                            # Delete files older than this many days

# ==============================
# COPY FILES FROM LOCAL TO UNC
# ==============================
Write-Host "Copying files from $LocalPath to $UNCPath ..." -ForegroundColor Cyan
try {
    # Ensure destination exists
    if (-not (Test-Path -LiteralPath $UNCPath)) {
        New-Item -ItemType Directory -Path $UNCPath -Force | Out-Null
        Write-Host "Created destination folder: $UNCPath"
    }

    # Copy files (overwrite if newer)
    Copy-Item -Path "$LocalPath\*" -Destination $UNCPath -Recurse -Force -ErrorAction Stop
    Write-Host "Copy completed successfully." -ForegroundColor Green
}
catch {
    Write-Error "Error copying files: $($_.Exception.Message)"
    exit 1
}

# ==============================
# DELETE OLD FILES FROM UNC
# ==============================
$Cutoff = (Get-Date).AddDays(-$Days)
Write-Host "Deleting files older than $Days days from $UNCPath ..." -ForegroundColor Cyan

try {
    Get-ChildItem -Path $UNCPath -File -Recurse -ErrorAction Stop |
        Where-Object { $_.LastWriteTime -lt $Cutoff } |
        ForEach-Object {
            try {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
                Write-Host "Deleted: $($_.FullName)"
            }
            catch {
                Write-Warning "Failed to delete: $($_.FullName) - $($_.Exception.Message)"
            }
        }
    Write-Host "Cleanup completed." -ForegroundColor Green
}
catch {
    Write-Error "Error accessing UNC path: $($_.Exception.Message)"
}
