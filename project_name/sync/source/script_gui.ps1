# Implement translation
$language = [System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName
$messages = @{
    "en" = @{
        "adminOk"                = "Running with administrator privileges."
        "adminFail"              = "Error: Not running with administrator privileges."
        "ffsInstalled"           = "FreeFileSync is installed."
        "ffsNotChangePath"       = "DO NOT CHANGE THE PROGRAM INSTALLATION PATH."
        "ffsNotInstalled"        = "FreeFileSync is not installed. Downloading and installing..."
        "ffsErrorInstallation"   = "Error installing FreeFileSync."
        "ffsSuccessInstallation" = "FreeFileSync has been successfully installed."
        "errorLoadConfig"        = "Failed to load settings."
        "errorSaveConfig"        = "Failed to save settings."
        "spacer"                 = "========================================"
        "addIgnoreDropbox"       = "Adding ignore rules for Dropbox"
        "folderNotFound"         = "Folder {0} not found. Checking again in {1} seconds..."
        "folderFound"            = "Folder found: "
        "appName"                = "Level Loomers Syncronization Script"
        "appTitle"               = "Level Loomers - Sync Script"
        "appDescription"         = "Synchronize CS2 addons with FreeFileSync"
        "labelNote1"             = "Path to CS2:"
        "tooltipNote1"           = "Full path to CS2 folder. Example: C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike 2"
        "labelNote2"             = "Addon's name:"
        "tooltipNote2"           = "Created addon on CS2 Workshop Tools. Example: de_talence"
        "labelNote3"             = "Your nickname:"
        "tooltipNote3"           = "User to identify upload. Example: twist"
        "buttonSync"             = "Synchronize"
        "buttonDesync"           = "Desynchronize"
        "buttonDiscord"          = "Join our Discord!"
        "linkDiscord"            = "https://discord.gg/hh39EczYG9"
        "successSync"            = "Successfully synchronized"
        "successDesync"          = "Successfully desynchronized"
        "desyncing"              = "Desynchronizing"
        "syncing"                = "Synchronizing"
    }
    "pt" = @{
        "adminOk"             = "Executando com privilégios de administrador."
        "adminFail"           = "Erro: obrigatório executar com privilégios de administrador."
        "ffsInstalled"        = "FreeFileSync está instalado."
        "ffsNotChangePath"    = "NÃO ALTERE O CAMINHO PADRAO DE INSTALAÇÃO DO FreeFileSync."
        "ffsNotInstalled"     = "FreeFileSync não está instalado. Baixando e instalando..."
        "errorInstallation"   = "Erro ao instalar FreeFileSync."
        "successInstallation" = "FreeFileSync foi instalado com sucesso."
        "errorLoadConfig"     = "Falha ao carregar configurações."
        "errorSaveConfig"     = "Falha ao salvar configurações."
        "spacer"              = "========================================"
        "addIgnoreDropbox"    = "Adicionando regras de exclusão para Dropbox"
        "folderNotFound"      = "Pasta {0} nao encontrada. Verificando novamente em {1} segundos..."
        "folderFound"         = "Pasta encontrada: "
        "appName"             = "Level Loomers Syncronization Script"
        "appTitle"            = "Level Loomers - Sync Script"
        "appDescription"      = "Sincronizar addons CS2 com FreeFileSync"
        "labelNote1"          = "Caminho para o CS2:"
        "tooltipNote1"        = "Caminho completo para o CS2. Exemplo: C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike 2"
        "labelNote2"          = "Nome do addon:"
        "tooltipNote2"        = "Nome do addon criado no CS2 Workshop Tools. Exemplo: de_talence"
        "labelNote3"          = "Seu nick:"
        "tooltipNote3"        = "Nick para identificar o upload. Exemplo: twist"
        "buttonSync"          = "Sincronizar"
        "buttonDesync"        = "Desincronizar"
        "buttonDiscord"       = "Grupo no Discord!"
        "linkDiscord"         = "https://discord.gg/hh39EczYG9"
        "successSync"         = "Sincronizado com sucesso"
        "successDesync"       = "Desincronizado com sucesso"
        "desyncing"           = "Desincronizando"
        "syncing"             = "Sincronizando"
    }
}

if (-not $messages.ContainsKey($language)) {
    $language = "en"
}

# Check if the current user has administrative privileges
$admin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($admin) {
    Write-Host $messages[$language]["adminOk"] -ForegroundColor Green
}
else {
    Write-Host $messages[$language]["adminFail"] -ForegroundColor Red
    Pause
    Exit
}


# install

# Define the path to check if FreeFileSync is installed
$freeFileSyncPath = "C:\Program Files\FreeFileSync\FreeFileSync.exe"



# Check if FreeFileSync executable exists
if (Test-Path $freeFileSyncPath -PathType Leaf) {
    Write-Host $messages[$language]["ffsInstalled"] -ForegroundColor Green
}
else {
    Write-Host $messages[$language]["ffsNotInstalled"] -ForegroundColor Yellow
    Write-Host $messages[$language]["ffsNotChangePath"] -ForegroundColor Cyan

    # Define the URL to download FreeFileSync setup
    $downloadUrl = "https://freefilesync.org/download/FreeFileSync_14.2_Windows_Setup.exe"

    # Define the path to save the setup file
    $setupFilePath = "$env:TEMP\FreeFileSync_14.2_Windows_Setup.exe"

    # Download FreeFileSync setup
    Invoke-WebRequest -Uri $downloadUrl -OutFile $setupFilePath

    # Install FreeFileSync
    Start-Process -FilePath $setupFilePath -ArgumentList "/S" -Wait

    # Check if installation was successful
    if (Test-Path $freeFileSyncPath -PathType Leaf) {
        Write-Host $messages[$language]["ffsSuccessInstallation"] -ForegroundColor Green
    }
    else {
        Write-Host $messages[$language]["ffsErrorInstallation"] -ForegroundColor Red
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
        }
        catch {
            Write-Host "$($messages[$language]["errorLoadConfig"]): $_" -ForegroundColor Red
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
    }
    catch {
        Write-Host "$($messages[$language]["errorSaveConfig"]): $_" -ForegroundColor Red
    }
}

# Function to open the Discord link in the default web browser
function Open-DiscordLink {
    $url = $messages[$language]["linkDiscord"]  # Replace with your actual Discord invite link
    if ($url -ne $null) {
        Start-Process $url
    }
}

# Root
$fontBox = New-Object System.Drawing.Font("Microsoft Sans Serif", 12)
$fontTitleLogo = New-Object System.Drawing.Font("Microsoft Sans Serif", 16, [System.Drawing.FontStyle]::Bold)
$fontTitleForm = New-Object System.Drawing.Font("Microsoft Sans Serif", 8)
$appBgColor = [System.Drawing.Color]::FromArgb(237, 236, 232)
$successColor = [System.Drawing.Color]::FromArgb(245, 254, 255)
$successAccentColor = [System.Drawing.Color]::FromArgb(54, 150, 64)
$failColor = [System.Drawing.Color]::FromArgb(250, 235, 235)
$failAccentColor = [System.Drawing.Color]::FromArgb(150, 54, 54)

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = $messages[$language]["appName"]
$form.Size = New-Object System.Drawing.Size(560, 400)
$form.BackColor = $appBgColor
$form.StartPosition = "CenterScreen"

# Set the minimum and maximum size of the form
$form.MinimumSize = New-Object System.Drawing.Size(560, 400)
$form.MaximumSize = New-Object System.Drawing.Size(560, 400)

# Create a label for the text logo
$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Location = New-Object System.Drawing.Point(20, 20)
$logoLabel.Size = New-Object System.Drawing.Size(500, 30)
$logoLabel.Font = $fontTitleLogo
$logoLabel.Text = $messages[$language]["appTitle"]
$logoLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($logoLabel)

# Create a label description for the text logo
$logoLabelDesc = New-Object System.Windows.Forms.Label
$logoLabelDesc.Location = New-Object System.Drawing.Point(20, 40)
$logoLabelDesc.Size = New-Object System.Drawing.Size(500, 30)
$logoLabelDesc.Font = $fontTitleForm
$logoLabelDesc.Text = $messages[$language]["appDescription"]
$logoLabelDesc.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($logoLabelDesc)

# Create a label for Path to cs2
$labelNote1 = New-Object System.Windows.Forms.Label
$labelNote1.Location = New-Object System.Drawing.Point(36, 80)
$labelNote1.Size = New-Object System.Drawing.Size(530, 15)
$labelNote1.Font = $fontTitleForm
$labelNote1.Text = $messages[$language]["labelNote1"]
$form.Controls.Add($labelNote1)

$labelInfoNote1 = New-Object System.Windows.Forms.PictureBox
$labelInfoNote1.Location = New-Object System.Drawing.Point(20, 80)
$labelInfoNote1.Size = New-Object System.Drawing.Size(13, 13) 
$labelInfoNote1.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$labelInfoNote1.Image = [System.Drawing.SystemIcons]::Question.ToBitmap() 
$form.Controls.Add($labelInfoNote1)

$toolTipNote1 = New-Object System.Windows.Forms.ToolTip
$toolTipNote1.SetToolTip($labelInfoNote1, $messages[$language]["toolTipNote1"])

# Create the first text box
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(20, 95)
$textBox1.Size = New-Object System.Drawing.Size(500, 30)
$textBox1.Font = $fontBox
$form.Controls.Add($textBox1)

# Create a label for the second text box notation
$labelNote2 = New-Object System.Windows.Forms.Label
$labelNote2.Location = New-Object System.Drawing.Point(36, 135)
$labelNote2.Size = New-Object System.Drawing.Size(220, 15)
$labelNote2.Font = $fontTitleForm
$labelNote2.Text = $messages[$language]["labelNote2"]
$form.Controls.Add($labelNote2)

$labelInfoNote2 = New-Object System.Windows.Forms.PictureBox
$labelInfoNote2.Location = New-Object System.Drawing.Point(20, 135)
$labelInfoNote2.Size = New-Object System.Drawing.Size(13, 13)
$labelInfoNote2.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$labelInfoNote2.Image = [System.Drawing.SystemIcons]::Question.ToBitmap()
$form.Controls.Add($labelInfoNote2)

$toolTipNote2 = New-Object System.Windows.Forms.ToolTip
$toolTipNote2.SetToolTip($labelInfoNote2, $messages[$language]["toolTipNote2"])

# Create the second text box
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(20, 150)
$textBox2.Size = New-Object System.Drawing.Size(245, 30)
$textBox2.Font = $fontBox
$form.Controls.Add($textBox2)

# Create a label for the third text box notation
$labelNote3 = New-Object System.Windows.Forms.Label
$labelNote3.Location = New-Object System.Drawing.Point(291, 135)
$labelNote3.Size = New-Object System.Drawing.Size(220, 15)
$labelNote3.Font = $fontTitleForm
$labelNote3.Text = $messages[$language]["labelNote3"]
$form.Controls.Add($labelNote3)

$labelInfoNote3 = New-Object System.Windows.Forms.PictureBox
$labelInfoNote3.Location = New-Object System.Drawing.Point(275, 135)
$labelInfoNote3.Size = New-Object System.Drawing.Size(13, 13)
$labelInfoNote3.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$labelInfoNote3.Image = [System.Drawing.SystemIcons]::Question.ToBitmap()
$form.Controls.Add($labelInfoNote3)

$toolTipNote3 = New-Object System.Windows.Forms.ToolTip
$toolTipNote3.SetToolTip($labelInfoNote3, $messages[$language]["toolTipNote3"])


# Create the third text box
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(275, 150)
$textBox3.Size = New-Object System.Drawing.Size(245, 15)
$textBox3.Font = $fontBox
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
$buttonSync.Location = New-Object System.Drawing.Point(147, 205)
$buttonSync.Size = New-Object System.Drawing.Size(250, 40)
$buttonSync.Text = $messages[$language]["buttonSync"]
$buttonSync.Font = $fontBox
$buttonSync.BackColor = $successColor
$buttonSync.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonSync.ForeColor = $successAccentColor

$form.Controls.Add($buttonSync)

# Create the desynchronize button
$buttonDesync = New-Object System.Windows.Forms.Button
$buttonDesync.Location = New-Object System.Drawing.Point(147, 255)
$buttonDesync.Size = New-Object System.Drawing.Size(250, 40)
$buttonDesync.Text = $messages[$language]["buttonDesync"]
$buttonDesync.Font = $fontBox
$buttonDesync.BackColor = $failColor
$buttonDesync.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonDesync.ForeColor = $failAccentColor
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
        Write-Host $messages[$language]["spacer"]
        Write-Host $messages[$language]["syncing"] $projectDirectory -ForegroundColor Yellow







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
            <Item>*.los</Item>
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



        Write-Host $messages[$language]["spacer"]
        Write-Host $messages[$language]["addIgnoreDropbox"] -ForegroundColor Cyan
        Write-Host $messages[$language]["spacer"]


        # List of folder paths to check
        $folderPaths = @("$projectDirectory\game_addons_$cs2addon", "$projectDirectory\content_addons_$cs2addon")

        # Set the interval time (in seconds) for checking
        $interval = 1

        # Loop through each folder path
        foreach ($folderPath in $folderPaths) {
            while (-not (Test-Path -Path $folderPath -PathType Container)) {
                Write-Host ($messages[$language]["folderNotFound"] -f $folderPath, $interval)
                Start-Sleep -Seconds $interval
            }
            Write-Host $messages[$language]["folderFound"] $folderPath
        }


        Set-Content -Path "$projectDirectory\game_addons_$cs2addon\sync.ffs_db" -Stream com.dropbox.ignored -Value 1
        Set-Content -Path "$projectDirectory\game_addons_$cs2addon\sync.sync.ffs_lock" -Stream com.dropbox.ignored -Value 1
        Set-Content -Path "$projectDirectory\content_addons_$cs2addon\sync.ffs_db" -Stream com.dropbox.ignored -Value 1
        Set-Content -Path "$projectDirectory\content_addons_$cs2addon\sync.sync.ffs_lock" -Stream com.dropbox.ignored -Value 1
        [System.Windows.Forms.MessageBox]::Show($messages[$language]["successSync"], "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })
# Create a label for the Discord link
$labelDiscord = New-Object System.Windows.Forms.LinkLabel
$labelDiscord.Location = New-Object System.Drawing.Point(20, 305)
$labelDiscord.Size = New-Object System.Drawing.Size(500, 30)
$labelDiscord.Font = $fontTitleForm
$labelDiscord.Text = $messages[$language]["buttonDiscord"]
$labelDiscord.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelDiscord.LinkArea = New-Object System.Windows.Forms.LinkArea(0, 25)
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
        Write-Host $messages[$language]["spacer"]
        Write-Host $messages[$language]["desyncing"] $projectDirectory -ForegroundColor Yellow

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


        [System.Windows.Forms.MessageBox]::Show($messages[$language]["successDesync"], "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })
# Register event handler for clicking the Discord link
$labelDiscord.Add_Click({
        Open-DiscordLink
    })

# Function to open the Discord link in the default web browser
function Open-DiscordLink {
    $url = $messages[$language]["linkDiscord"]  # Replace with your actual Discord invite link
    if ($url -ne $null) {
        Start-Process $url
    }
}

# Show the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()






