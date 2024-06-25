# Check if the current user has administrative privileges
$admin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($admin) {
    Write-Host "Running with administrator privileges." -ForegroundColor Green
} else {
    Write-Host "Not running with administrator privileges." -ForegroundColor Red
    Pause
    Exit
}





# install

# Define the path to check if FreeFileSync is installed
$freeFileSyncPath = "C:\Program Files\FreeFileSync\FreeFileSync.exe"



# Check if FreeFileSync executable exists
if (Test-Path $freeFileSyncPath -PathType Leaf) {
    Write-Output "FreeFileSync is already installed."
} else {
    Write-Host "DO NOT CHANGE THE PROGRAM INSTALLATION PATH." -ForegroundColor Red
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





#GUI


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define a configuration file path where user settings will be stored
$settingsFilePath = "$env:APPDATA\SS_LevelLoomers.txt"

# Function to load settings from the configuration file
function Load-Settings {
    if (Test-Path $settingsFilePath) {
        try {
            $settings = Get-Content $settingsFilePath -Raw | ConvertFrom-Json
            $textBox1.Text = $settings.TextBox1
            $textBox2.Text = $settings.TextBox2
            $textBox3.Text = $settings.TextBox3
        } catch {
            Write-Warning "Failed to load settings: $_"
        }
    }
}

# Function to save settings to the configuration file
function Save-Settings {
    $settings = @{
        TextBox1 = $textBox1.Text
        TextBox2 = $textBox2.Text
        TextBox3 = $textBox3.Text
    } | ConvertTo-Json

    try {
        $settings | Set-Content -Path $settingsFilePath -Force
    } catch {
        Write-Warning "Failed to save settings: $_"
    }
}

# Function to open the Discord link in the default web browser
function Open-DiscordLink {
    $url = "https://discord.gg/hh39EczYG9"  # Replace with your actual Discord invite link
    if ($url -ne $null) {
        Start-Process $url
    }
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Level Loomers Synchronization Script"
$form.Size = New-Object System.Drawing.Size(560, 400)
$form.StartPosition = "CenterScreen"

# Set the minimum and maximum size of the form
$form.MinimumSize = New-Object System.Drawing.Size(560, 400)
$form.MaximumSize = New-Object System.Drawing.Size(560, 400)

# Define a larger font
$font = New-Object System.Drawing.Font("Microsoft Sans Serif", 12)
# Define a larger font for the logo
$logoFont = New-Object System.Drawing.Font("Microsoft Sans Serif", 16, [System.Drawing.FontStyle]::Bold)

# Create a label for the text logo
$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Location = New-Object System.Drawing.Point(20, 20)
$logoLabel.Size = New-Object System.Drawing.Size(500, 30)
$logoLabel.Font = $logoFont
$logoLabel.Text = "Level Loomers - Sync Script"
$logoLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$logoLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($logoLabel)

# Create a label for Path to cs2
$labelNote1 = New-Object System.Windows.Forms.Label
$labelNote1.Location = New-Object System.Drawing.Point(20, 60)
$labelNote1.Size = New-Object System.Drawing.Size(500, 15)
$labelNote1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 8)
$labelNote1.Text = "Path to cs2. Example: E:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive"
$form.Controls.Add($labelNote1)

# Create the first text box
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(20, 75)
$textBox1.Size = New-Object System.Drawing.Size(500, 30)
$textBox1.Font = $font
$textBox1.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($textBox1)

# Create a label for the second text box notation
$labelNote2 = New-Object System.Windows.Forms.Label
$labelNote2.Location = New-Object System.Drawing.Point(20, 115)
$labelNote2.Size = New-Object System.Drawing.Size(500, 15)
$labelNote2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 8)
$labelNote2.Text = "Addon's name. Example: de_talence"
$form.Controls.Add($labelNote2)

# Create the second text box
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(20, 130)
$textBox2.Size = New-Object System.Drawing.Size(500, 30)
$textBox2.Font = $font
$textBox2.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($textBox2)

# Create a label for the third text box notation
$labelNote3 = New-Object System.Windows.Forms.Label
$labelNote3.Location = New-Object System.Drawing.Point(20, 170)
$labelNote3.Size = New-Object System.Drawing.Size(500, 15)
$labelNote3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 8)
$labelNote3.Text = "Your nickname. Example: twist"
$form.Controls.Add($labelNote3)

# Create the third text box
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(20, 185)
$textBox3.Size = New-Object System.Drawing.Size(500, 30)
$textBox3.Font = $font
$textBox3.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($textBox3)

# Load settings when the form is loaded
$form.Add_Load({
    Load-Settings
})

# Save settings when the form is closing
$form.Add_FormClosing({
    Save-Settings
})

# Create the synchronize button
$buttonSync = New-Object System.Windows.Forms.Button
$buttonSync.Location = New-Object System.Drawing.Point(20, 225)
$buttonSync.Size = New-Object System.Drawing.Size(500, 40)
$buttonSync.Text = "Synchronize"
$buttonSync.Font = $font
$buttonSync.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($buttonSync)

# Create the desynchronize button
$buttonDesync = New-Object System.Windows.Forms.Button
$buttonDesync.Location = New-Object System.Drawing.Point(20, 275)
$buttonDesync.Size = New-Object System.Drawing.Size(500, 40)
$buttonDesync.Text = "Desynchronize"
$buttonDesync.Font = $font
$buttonDesync.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($buttonDesync)

#sync logic

$buttonSync.Add_Click({
    $cs2path = $textBox1.Text
    $cs2addon = $textBox2.Text
    $user = $textBox3.Text

    $cs2path = [string]$cs2path
    $cs2addon = [string]$cs2addon

    $scriptDirectory = $PWD.Path 
    $projectDirectory = Split-Path -Path $scriptDirectory -Parent
    Echo "========================================"
    echo $projectDirectory 







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



    Write-Host "========================================"
    Write-Host "Adding ignore rules for Dropbox" -ForegroundColor Blue
    Write-Host "========================================"


    # List of folder paths to check
    $folderPaths = @("$projectDirectory\game_addons_$cs2addon", "$projectDirectory\content_addons_$cs2addon")

    # Set the interval time (in seconds) for checking
    $interval = 1

    # Loop through each folder path
    foreach ($folderPath in $folderPaths) {
        while (-not (Test-Path -Path $folderPath -PathType Container)) {
            Write-Output "Folder $folderPath not found. Checking again in $interval seconds..."
            Start-Sleep -Seconds $interval
        }
        Write-Output "Folder found: $folderPath"
    }


    Set-Content -Path "$projectDirectory\game_addons_$cs2addon\sync.ffs_db" -Stream com.dropbox.ignored -Value 1

    Set-Content -Path "$projectDirectory\game_addons_$cs2addon\sync.sync.ffs_lock" -Stream com.dropbox.ignored -Value 1

    Set-Content -Path "$projectDirectory\content_addons_$cs2addon\sync.ffs_db" -Stream com.dropbox.ignored -Value 1
    
    Set-Content -Path "$projectDirectory\content_addons_$cs2addon\sync.sync.ffs_lock" -Stream com.dropbox.ignored -Value 1

    [System.Windows.Forms.MessageBox]::Show("Successfully synchronized", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
# Create a label for the Discord link
$labelDiscord = New-Object System.Windows.Forms.LinkLabel
$labelDiscord.Location = New-Object System.Drawing.Point(20, 325)
$labelDiscord.Size = New-Object System.Drawing.Size(500, 30)
$labelDiscord.Font = $font
$labelDiscord.Text = "Join our Discord!"
$labelDiscord.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelDiscord.LinkArea = New-Object System.Windows.Forms.LinkArea(0, 20)
$labelDiscord.LinkBehavior = 'HoverUnderline'
$form.Controls.Add($labelDiscord)

#desync logic
$buttonDesync.Add_Click({
    $cs2path = $textBox1.Text
    $cs2addon = $textBox2.Text
    $user = $textBox3.Text

    $cs2path = [string]$cs2path
    $cs2addon = [string]$cs2addon

    $scriptDirectory = $PWD.Path 
    $projectDirectory = Split-Path -Path $scriptDirectory -Parent
    Write-Host "========================================"
    Write-Host $projectDirectory 

    Get-Process -Name "*RealTimeSync*" | Stop-Process -Force


    $target = "$env:SystemDrive\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
    Remove-Item -Path "$target\game_csgo_addons_$cs2addon.ffs_real" -Force
    Remove-Item -Path "$target\content_csgo_addons_$cs2addon.ffs_real" -Force

    # Get all files with the extension .ffs_real in the specified folder
    $fileList = Get-ChildItem -Path $target -Filter "*.ffs_real"

    # Iterate through each file and start a process for it
    foreach ($file in $fileList) {
        # Construct the full path to the file
        $filePath = Join-Path -Path $target -ChildPath $file.Name
    
        # Start a process for the file
        Start-Process -FilePath $filePath
    }


    [System.Windows.Forms.MessageBox]::Show("Successfully desynchronized", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
# Register event handler for clicking the Discord link
$labelDiscord.Add_Click({
    Open-DiscordLink
})

# Function to open the Discord link in the default web browser
function Open-DiscordLink {
    $url = "https://discord.gg/hh39EczYG9"  # Replace with your actual Discord invite link
    if ($url -ne $null) {
        Start-Process $url
    }
}

# Show the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()






