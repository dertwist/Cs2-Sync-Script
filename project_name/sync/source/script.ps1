Write-host "----------------
Level Loomers
----Discord----
https://discord.gg/hh39EczYG9
-----------------
"




# Check if the current user has administrative privileges
$admin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($admin) {
    Write-Host "Running with administrator privileges." -ForegroundColor Green
} else {
    Write-Host "Not running with administrator privileges." -ForegroundColor Red
    Pause
    Exit
}




$scriptDirectory = $PWD.Path 
$projectDirectory = Split-Path -Path $scriptDirectory -Parent
Echo "========================================"
echo $projectDirectory 



$cs2path = "E:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive"
Echo "========================================"
Write-Host "Example: $cs2path" -ForegroundColor Yellow
$cs2path = Read-Host -Prompt "Enter path to Cs2"
$cs2path = [string]$cs2path

Echo "========================================"
$cs2addon = "de_talence"
Write-Host "Example: $cs2addon" -ForegroundColor Yellow
$cs2addon = Read-Host -Prompt "Enter Cs2 addon name"
$cs2addon = [string]$cs2addon
Echo "========================================"

$user = "twist"
Write-Host "Example: $user" -ForegroundColor Yellow
$user = Read-Host -Prompt "Enter your nickname"
Echo "========================================"





# install

# Define the path to check if FreeFileSync is installed
$freeFileSyncPath = "C:\Program Files\FreeFileSync\FreeFileSync.exe"



# Check if FreeFileSync executable exists
if (Test-Path $freeFileSyncPath -PathType Leaf) {
    Write-Output "FreeFileSync is already installed."
} else {
    Write-Output "FreeFileSync is not installed. Downloading and installing..."

    # Define the URL to download FreeFileSync setup
    $downloadUrl = "https://www.freefilesync.org/download/FreeFileSync_13.6_Windows_Setup.exe"

    # Define the path to save the setup file
    $setupFilePath = "$env:TEMP\FreeFileSync_13.6_Windows_Setup.exe"

    # Download FreeFileSync setup
    Invoke-WebRequest -Uri $downloadUrl -OutFile $setupFilePath

    # Install FreeFileSync
    Start-Process -FilePath $setupFilePath -ArgumentList "/S" -Wait

    # Check if installation was successful
    if (Test-Path $freeFileSyncPath -PathType Leaf) {
        Write-Output "FreeFileSync has been successfully installed."
    } else {
        Write-Output "Failed to install FreeFileSync."
    }

    # Clean up the setup file
    Remove-Item $setupFilePath -Force
}




# batch
$xmlContent = @"
<?xml version="1.0" encoding="utf-8"?>
<FreeFileSync XmlType="BATCH" XmlFormat="23">
    <Notes/>
    <Compare>
        <Variant>TimeAndSize</Variant>
        <Symlinks>Exclude</Symlinks>
        <IgnoreTimeShift/>
    </Compare>
    <Synchronize>
        <Changes>
            <Left Create="right" Update="right" Delete="right"/>
            <Right Create="left" Update="left" Delete="left"/>
        </Changes>
        <DeletionPolicy>Permanent</DeletionPolicy>
        <VersioningFolder Style="Replace"/>
    </Synchronize>
    <Filter>
        <Include>
            <Item>*</Item>
        </Include>
        <Exclude>
            <Item>\System Volume Information\</Item>
            <Item>\$Recycle.Bin\</Item>
            <Item>\RECYCLE?\</Item>
            <Item>\Recovery\</Item>
            <Item>*\thumbs.db</Item>
            <Item> *.assbin | *.tbscene *.blend1 | *.tbscene | *highpoly* | *.sbsar | *.spp | *.zbr</Item>
        </Exclude>
        <SizeMin Unit="None">0</SizeMin>
        <SizeMax Unit="None">0</SizeMax>
        <TimeSpan Type="None">0</TimeSpan>
    </Filter>
    <FolderPairs>
        <Pair>
            <Left>$cs2path\content\csgo_addons\$cs2addon</Left>
            <Right>$projectDirectory\content_addons_$cs2addon</Right>
        </Pair>
    </FolderPairs>
    <Errors Ignore="true" Retry="1" Delay="5"/>
    <PostSyncCommand Condition="Completion"/>
    <LogFolder/>
    <EmailNotification Condition="Always"/>
    <GridViewType>Action</GridViewType>
    <Batch>
        <ProgressDialog Minimized="true" AutoClose="true"/>
        <ErrorDialog>Show</ErrorDialog>
        <PostSyncAction>None</PostSyncAction>
    </Batch>
</FreeFileSync>
"@

$xmlGame = @"
<?xml version="1.0" encoding="utf-8"?>
<FreeFileSync XmlType="BATCH" XmlFormat="23">
    <Notes/>
    <Compare>
        <Variant>TimeAndSize</Variant>
        <Symlinks>Exclude</Symlinks>
        <IgnoreTimeShift/>
    </Compare>
    <Synchronize>
        <Changes>
            <Left Create="right" Update="right" Delete="right"/>
            <Right Create="left" Update="left" Delete="left"/>
        </Changes>
        <DeletionPolicy>Permanent</DeletionPolicy>
        <VersioningFolder Style="Replace"/>
    </Synchronize>
    <Filter>
        <Include>
            <Item>*\panorama\</Item>
            <Item>*</Item>
            <Item>\panorama\</Item>
        </Include>
        <Exclude>
            <Item>\System Volume Information\</Item>
            <Item>\$Recycle.Bin\</Item>
            <Item>\RECYCLE?\</Item>
            <Item>\Recovery\</Item>
            <Item>*\thumbs.db</Item>
            <Item>*\models\</Item>
            <Item>*\_vrad3\</Item>
            <Item>*backup_round*.txt</Item>
            <Item>\tools_thumbnail_cache.bin</Item>
            <Item>\tools_asset_info.bin</Item>
            <Item>\ServerConfig.vdf</Item>
            <Item>*.vmat_c</Item>
            <Item>\materials\</Item>
        </Exclude>
        <SizeMin Unit="None">0</SizeMin>
        <SizeMax Unit="None">0</SizeMax>
        <TimeSpan Type="None">0</TimeSpan>
    </Filter>
    <FolderPairs>
        <Pair>
            <Left>$cs2path\game\csgo_addons\$cs2addon</Left>
            <Right>$projectDirectory\game_addons_$cs2addon</Right>
        </Pair>
    </FolderPairs>
    <Errors Ignore="true" Retry="1" Delay="5"/>
    <PostSyncCommand Condition="Completion"/>
    <LogFolder/>
    <EmailNotification Condition="Always"/>
    <GridViewType>Action</GridViewType>
    <Batch>
        <ProgressDialog Minimized="true" AutoClose="true"/>
        <ErrorDialog>Show</ErrorDialog>
        <PostSyncAction>None</PostSyncAction>
    </Batch>
</FreeFileSync>
"@

# Define the directory path
$directoryPath = "$scriptDirectory\users\$user"

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    New-Item -Path $directoryPath -ItemType Directory -Force
}

$xmlContent | Out-File -FilePath "$directoryPath\content_csgo_addons_$cs2addon.ffs_batch" -Encoding utf8
$xmlGame | Out-File -FilePath "$directoryPath\game_csgo_addons_$cs2addon.ffs_batch" -Encoding utf8


# realsync

$xmlContent_Realsync = @"
<?xml version="1.0" encoding="utf-8"?>
<FreeFileSync XmlType="REAL" XmlFormat="2">
    <Directories>
        <Item>$cs2path\content\csgo_addons\$cs2addon</Item>
        <Item>$projectDirectory\content_addons_$cs2addon</Item>
    </Directories>
    <Delay>3</Delay>
    <Commandline>"C:\Program Files\FreeFileSync\FreeFileSync.exe" "$directoryPath\content_csgo_addons_$cs2addon.ffs_batch"</Commandline>
</FreeFileSync>
"@

# $xmlContent_Realsync | Out-File -FilePath "$directoryPath\content_csgo_addons_$cs2addon.ffs_real" -Encoding utf8



$xmlGame_Realsync = @"
<?xml version="1.0" encoding="utf-8"?>
<FreeFileSync XmlType="REAL" XmlFormat="2">
    <Directories>
        <Item>$cs2path\game\csgo_addons\$cs2addon</Item>
        <Item>$projectDirectory\game_addons_$cs2addon</Item>
    </Directories>
    <Delay>3</Delay>
    <Commandline>"C:\Program Files\FreeFileSync\FreeFileSync.exe" "$directoryPath\game_csgo_addons_$cs2addon.ffs_batch"</Commandline>
</FreeFileSync>
"@

# $xmlGame_Realsync | Out-File -FilePath "$directoryPath\game_csgo_addons_$cs2addon.ffs_real" -Encoding utf8





# startup
$target = "$env:SystemDrive\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

$xmlContent_Realsync | Out-File -FilePath "$target\content_csgo_addons_$cs2addon.ffs_real" -Encoding utf8
$xmlGame_Realsync | Out-File -FilePath "$target\game_csgo_addons_$cs2addon.ffs_real" -Encoding utf8


#runs
Start-Process $target\game_csgo_addons_$cs2addon.ffs_real
Start-Process $target\content_csgo_addons_$cs2addon.ffs_real
Start-Process $directoryPath\game_csgo_addons_$cs2addon.ffs_batch
Start-Process $directoryPath\content_csgo_addons_$cs2addon.ffs_batch



Echo "========================================"
Write-Host "Adding ignore rules for Dropbox" -ForegroundColor Blue
Echo "========================================"

Set-Content -Path "$projectDirectory\game_addons_$cs2addon\sync.ffs_db" -Stream com.dropbox.ignored -Value 1

Set-Content -Path "$projectDirectory\content_addons_$cs2addon\sync.ffs_db" -Stream com.dropbox.ignored -Value 1

Read-Host -Prompt "Press any key to close"