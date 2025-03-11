$scriptToRun = "./script_gui.ps1"
$lastWriteTime = (Get-Item $scriptToRun).LastWriteTime

while ($true) {
    $currentWriteTime = (Get-Item $scriptToRun).LastWriteTime
    if ($currentWriteTime -ne $lastWriteTime) {
        Clear-Host
        Write-Host "Script changed! Close app to reload..."
        $lastWriteTime = $currentWriteTime
        & $scriptToRun 
    }
    Start-Sleep -Seconds 1
}
