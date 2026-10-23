# Instala o Valor Mortis VR na pasta do jogo (Steam ou Xbox Game Pass). Chamado pelo instalar.bat.
# Uso: instalar.bat            -> acha o jogo sozinho (Steam e Game Pass)
#      instalar.bat "D:\...\ValorMortis\Binaries\Win64"   -> pasta indicada por voce (a pasta do executavel do jogo)
# Grava um relatorio (relatorio-instalacao.txt, ao lado deste arquivo) para mandar se algo der errado.
#      instalar.bat -SemConfigDoAutor   -> nao mexe nos graficos do jogo nem nas opcoes (so instala/atualiza o mod)
#      instalar.bat -ConfigDoAutor      -> aplica a configuracao do autor de novo (mesmo se ja foi aplicada)
param([string]$GameBin = '', [switch]$SemConfigDoAutor, [switch]$ConfigDoAutor)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$files = Join-Path $here 'arquivos'
$report = Join-Path $here 'relatorio-instalacao.txt'
Set-Content -Path $report -Value "Valor Mortis VR - relatorio de instalacao $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -Encoding utf8
function Note($msg) { Add-Content -Path $report -Value $msg -Encoding utf8 }
function Fail($msg) {
    Note "ERRO: $msg"
    Write-Host ''; Write-Host $msg -ForegroundColor Red
    Write-Host 'Mande o arquivo relatorio-instalacao.txt (nesta pasta) para quem fez o mod.' -ForegroundColor Yellow
    exit 1
}
# Executavel do jogo numa pasta: Steam = ValorMortis-Win64-Shipping.exe; Game Pass = outro nome (ex. ...-WinGDK-Shipping.exe)
function Find-Exe($dir) {
    if (-not $dir -or -not (Test-Path $dir)) { return $null }
    return Get-ChildItem -Path $dir -Filter 'ValorMortis*-Shipping.exe' -File -ErrorAction SilentlyContinue | Select-Object -First 1
}

function Find-SteamBin {
    $libs = New-Object System.Collections.Generic.List[string]
    $steam = $null
    foreach ($k in 'HKCU:\Software\Valve\Steam', 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam', 'HKLM:\SOFTWARE\Valve\Steam') {
        $v = Get-ItemProperty -Path $k -ErrorAction SilentlyContinue
        if ($v) {
            if ($v.SteamPath) { $steam = $v.SteamPath } elseif ($v.InstallPath) { $steam = $v.InstallPath }
            if ($steam) { break }
        }
    }
    if ($steam) {
        $steam = $steam -replace '/', '\'
        $libs.Add($steam)
        $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) {
                $libs.Add(($m.Groups[1].Value -replace '\\\\', '\'))
            }
        }
    }
    foreach ($l in $libs) {
        $bin = Join-Path $l 'steamapps\common\Valor Mortis\ValorMortis\Binaries\Win64'
        if (Find-Exe $bin) { return $bin }
    }
    return $null
}

# Xbox Game Pass (app Xbox): pasta XboxGames de cada disco (com "Gerenciamento avancado"/mods ligado a pasta fica aberta)
function Find-GamePassBin {
    $roots = @()
    foreach ($d in (Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) {
        foreach ($sub in 'XboxGames', 'Program Files\ModifiableWindowsApps', 'Games') {
            $p = Join-Path $d.Root $sub
            if (Test-Path $p) { $roots += $p }
        }
    }
    foreach ($r in $roots) {
        foreach ($g in (Get-ChildItem -Path $r -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like '*Valor*Mortis*' })) {
            Note "Game Pass: pasta candidata $($g.FullName)"
            $exe = Get-ChildItem -Path $g.FullName -Filter 'ValorMortis*-Shipping.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($exe) { return $exe.DirectoryName }
            Note "  (sem ValorMortis*-Shipping.exe dentro: pasta protegida? ligue 'Gerenciamento avancado' no app Xbox)"
        }
    }
    return $null
}

Write-Host '=== Valor Mortis VR - instalador ===' -ForegroundColor Cyan
Note "Windows: $([Environment]::OSVersion.VersionString); PowerShell $($PSVersionTable.PSVersion)"
if (-not (Test-Path (Join-Path $files 'version.dll'))) {
    Fail 'Pasta "arquivos" nao encontrada. Extraia o ZIP inteiro antes de rodar o instalador.'
}

$store = ''
if ($GameBin) { $bin = $GameBin.Trim('"'); $store = 'pasta indicada' }
else {
    $bin = Find-SteamBin
    if ($bin) { $store = 'Steam' } else { $bin = Find-GamePassBin; if ($bin) { $store = 'Xbox Game Pass' } }
}
if (-not $bin -or -not (Find-Exe $bin)) {
    Write-Host 'Nao achei o Valor Mortis (Steam ou Game Pass).' -ForegroundColor Yellow
    Write-Host 'Cole aqui a pasta onde fica o executavel do jogo (ValorMortis-...-Shipping.exe), por exemplo:'
    Write-Host '  Steam:     D:\SteamLibrary\steamapps\common\Valor Mortis\ValorMortis\Binaries\Win64'
    Write-Host '  Game Pass: C:\XboxGames\Valor Mortis\Content\ValorMortis\Binaries\WinGDK'
    $bin = (Read-Host 'Pasta').Trim('"')
    $store = 'pasta indicada'
    if (-not (Find-Exe $bin)) { Fail "Nao achei ValorMortis*-Shipping.exe em: $bin" }
}
$exe = Find-Exe $bin
$exeName = $exe.Name
$stem = [IO.Path]::GetFileNameWithoutExtension($exeName)
Write-Host "Jogo encontrado ($store) em: $bin"
Note "Loja: $store"
Note "Pasta: $bin"
Note "Executavel: $exeName ($($exe.Length) bytes, $($exe.LastWriteTime))"
try { Note "Versao do arquivo: $($exe.VersionInfo.FileVersion) / produto $($exe.VersionInfo.ProductVersion)" } catch {}
if ($store -eq 'Xbox Game Pass' -or $exeName -ne 'ValorMortis-Win64-Shipping.exe') {
    Write-Host 'Versao do Game Pass (ou outro executavel): suporte EXPERIMENTAL. O mod procura os enderecos sozinho ao abrir o jogo.' -ForegroundColor Yellow
}

if (Get-Process -Name $stem -ErrorAction SilentlyContinue) {
    Fail 'Feche o Valor Mortis antes de instalar.'
}

# a pasta aceita arquivos novos?
try {
    $probe = Join-Path $bin 'valormortisvr-teste.tmp'
    Set-Content -Path $probe -Value 'x'
    Remove-Item $probe -Force
    Note 'Pasta do jogo: gravacao ok'
} catch {
    Fail "Sem permissao para gravar na pasta do jogo ($bin). No Game Pass: no app Xbox, nas opcoes do Valor Mortis, ligue o gerenciamento avancado/mods e instale o jogo de novo nessa pasta; ou rode o instalador como administrador."
}

$vr = Join-Path $bin 'ValorMortisVR'
$plugins = Join-Path $vr "dados\UnrealVRMod\$stem\plugins"
$update = Test-Path (Join-Path $plugins 'ValorMortisVR.dll')

# Se ja existia outro version.dll (de outro mod), guarda uma copia antes de trocar.
$dstVersion = Join-Path $bin 'version.dll'
$srcVersion = Join-Path $files 'version.dll'
if ((Test-Path $dstVersion) -and ((Get-FileHash $dstVersion).Hash -ne (Get-FileHash $srcVersion).Hash)) {
    $bak = Join-Path $bin 'version.dll.antes-valormortisvr'
    if (-not (Test-Path $bak)) { Copy-Item $dstVersion $bak; Write-Host 'Copia do version.dll antigo: version.dll.antes-valormortisvr'; Note 'version.dll antigo guardado' }
}

try {
    New-Item -ItemType Directory -Force (Join-Path $vr 'perfil') | Out-Null
    New-Item -ItemType Directory -Force $plugins | Out-Null
    Copy-Item $srcVersion $dstVersion -Force
    foreach ($f in 'UEVRBackend.dll', 'openxr_loader.dll', 'LuaVR.dll') {
        Copy-Item (Join-Path $files "ValorMortisVR\$f") (Join-Path $vr $f) -Force
    }
    Copy-Item (Join-Path $files 'ValorMortisVR\perfil\config.txt') (Join-Path $vr 'perfil\config.txt') -Force
    Copy-Item (Join-Path $files 'plugin\ValorMortisVR.dll') (Join-Path $plugins 'ValorMortisVR.dll') -Force
    Copy-Item (Join-Path $here 'coletar-logs.ps1') (Join-Path $vr 'coletar-logs.ps1') -Force -ErrorAction SilentlyContinue
    # nucleo do fork joeyhodge/UEVR (opcional, desligado): ligar/desligar pelos .bat; a escolha (usar-nucleo-fork.txt) nao e mexida
    $forkSrc = Join-Path $files 'ValorMortisVR\nucleo-fork'
    if (Test-Path $forkSrc) {
        New-Item -ItemType Directory -Force (Join-Path $vr 'nucleo-fork') | Out-Null
        foreach ($f in Get-ChildItem $forkSrc -File) { Copy-Item $f.FullName (Join-Path $vr "nucleo-fork\$($f.Name)") -Force }
        foreach ($f in 'nucleo-fork-LIGAR.bat', 'nucleo-fork-DESLIGAR.bat') {
            $src = Join-Path $files "ValorMortisVR\$f"
            if (Test-Path $src) { Copy-Item $src (Join-Path $vr $f) -Force }
        }
    }
} catch {
    Fail "A copia falhou: $($_.Exception.Message)"
}

# Ajustes e calibracao: so entram se ainda nao existirem (uma atualizacao nunca apaga o que voce ajustou).
$kept = 0; $added = 0
foreach ($f in Get-ChildItem (Join-Path $files 'padroes') -File) {
    $dst = Join-Path $plugins $f.Name
    if (Test-Path $dst) { $kept++ } else { Copy-Item $f.FullName $dst; $added++ }
}

# Configuracao do autor (arquivos\config-do-autor): graficos do jogo (upscaler FSR, qualidade, brilho...), configuracao
# do UEVR e opcoes/calibracao do mod iguais as do jogo de quem fez o mod (testado assim; outro upscaler ou o Stereo Fix
# ligado estragam um olho). Aplicada uma vez por versao da configuracao (nao apaga ajustes a cada atualizacao); o que
# existia vai para copias. Do jogo de quem instala ficam so a resolucao/janela/HDR do monitor e o teste de desempenho.
$cfg = Join-Path $files 'config-do-autor'
$cfgApplied = $false
# Placa de video (23/10: Game Pass com NVIDIA RTX 4070 SUPER: com o FSR da config do autor - placa AMD, FSR 4 - o Native
# Stereo normal mostrava so o olho esquerdo). So na AMD o upscaler do autor e aplicado; nas outras fica o upscaler que a
# pessoa tinha antes do mod (copia mais antiga) ou, sem copia, o jogo escolhe o padrao dele para a placa.
$gpuNames = @()
try { $gpuNames = @(Get-CimInstance Win32_VideoController -ErrorAction Stop | ForEach-Object { $_.Name }) } catch {}
$vendor = if ($gpuNames -match 'NVIDIA|GeForce|RTX|GTX') { 'nvidia' } elseif ($gpuNames -match 'Radeon') { 'amd' } elseif ($gpuNames -match 'Intel') { 'intel' } else { 'outra' }
Note "placa de video: $vendor ($($gpuNames -join '; '))"
$upKeys = 'UpscalerIndex', 'bUpscalerSetByUser', 'bUpscalerDefaultsApplied', 'ResolutionScale', 'UpscalerResolutionScale', 'ActiveFrameGen', 'PendingFrameGen',
    'bDLSSEnabled', 'DLSSMode', 'DLSSFGMode', 'DLSSReflexMode', 'bFSREnabled', 'FSRMode', 'bFSRFGEnabled', 'bXeSSEnabled', 'bXeSSFGEnabled', 'XeSSMode',
    'XeLLModeEnabled', 'bAntiLag2Enabled'
if ((Test-Path $cfg) -and -not $SemConfigDoAutor) {
    # versao 2 da regra (placa de video) e a marca da placa entram na marca: quem ja tinha recebido a config recebe de novo, 1 vez
    $cfgHash = (((Get-ChildItem $cfg -Recurse -File | Sort-Object FullName | ForEach-Object { (Get-FileHash $_.FullName).Hash }) -join '') + "|cfg2|$vendor")
    $cfgHash = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::ASCII.GetBytes($cfgHash))).Replace('-', '').Substring(0, 16)
    $stateDir = Join-Path $env:LOCALAPPDATA 'ValorMortisVR'
    New-Item -ItemType Directory -Force $stateDir | Out-Null
    $stampFile = Join-Path $stateDir 'config-do-autor-aplicada.txt'
    $last = if (Test-Path $stampFile) { (Get-Content $stampFile -Raw).Trim() } else { '' }
    if ($ConfigDoAutor -or $last -ne $cfgHash) {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $bak = Join-Path $vr "copias-antes-config-do-autor\$stamp"
        New-Item -ItemType Directory -Force $bak | Out-Null

        # 1) graficos do jogo (GameUserSettings.ini): Steam em %LOCALAPPDATA%\ValorMortis\Saved; Game Pass na pasta do pacote
        $saveds = @(Join-Path $env:LOCALAPPDATA 'ValorMortis\Saved')
        foreach ($pk in (Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Packages') -Directory -Filter '*ValorMortis*' -ErrorAction SilentlyContinue)) {
            $saveds += (Join-Path $pk.FullName 'LocalCache\Local\ValorMortis\Saved')
        }
        $targets = @()
        foreach ($s in $saveds) {
            $targets += @(Get-ChildItem (Join-Path $s 'Config') -Recurse -Filter 'GameUserSettings.ini' -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
        }
        if (-not $targets) {
            # jogo nunca aberto: cria onde ele vai ler
            $targets += (Join-Path $saveds[0] 'Config\Windows\GameUserSettings.ini')
            if ($store -ne 'Steam') { foreach ($s in $saveds | Select-Object -Skip 1) { $targets += (Join-Path $s 'Config\Windows\GameUserSettings.ini') } }
        }
        $keep = 'ResolutionSizeX', 'ResolutionSizeY', 'LastUserConfirmedResolutionSizeX', 'LastUserConfirmedResolutionSizeY', 'FullscreenMode',
            'LastConfirmedFullscreenMode', 'PreferredFullscreenMode', 'DesiredScreenWidth', 'DesiredScreenHeight', 'LastUserConfirmedDesiredScreenWidth',
            'LastUserConfirmedDesiredScreenHeight', 'LastRecommendedScreenWidth', 'LastRecommendedScreenHeight', 'LastCPUBenchmarkResult',
            'LastGPUBenchmarkResult', 'LastCPUBenchmarkSteps', 'LastGPUBenchmarkSteps', 'LastGPUBenchmarkMultiplier', 'bUseHDRDisplayOutput', 'HDRDisplayOutputNits'
        $author = Get-Content (Join-Path $cfg 'jogo\GameUserSettings.ini')
        $restoreList = Join-Path $stateDir 'graficos-antes-do-mod.txt'
        foreach ($t in $targets) {
            $mine = @()
            if (Test-Path $t) {
                $mine = @(Get-Content $t | Where-Object { $_ -match '^([^=;\[]+)=' -and $keep -contains $Matches[1] })
                $b = "$t.antes-valormortisvr-$stamp"
                Copy-Item $t $b
                # a copia mais antiga (antes do mod mexer pela primeira vez) e a que o desinstalador devolve
                if (-not ((Test-Path $restoreList) -and (Select-String -Path $restoreList -SimpleMatch "$t|" -Quiet))) { Add-Content $restoreList "$t|$b" -Encoding utf8 }
            }
            # placa que nao e AMD: upscaler de antes do mod (ou o padrao do jogo para a placa)
            $up = @()
            $upFrom = ''
            if ($vendor -ne 'amd') {
                $orig = $null
                if (Test-Path $restoreList) {
                    $hit = Get-Content $restoreList | Where-Object { $_.StartsWith("$t|") } | Select-Object -First 1
                    if ($hit) { $orig = $hit.Substring($t.Length + 1) }
                }
                if ($orig -and (Test-Path $orig)) {
                    $up = @(Get-Content $orig | Where-Object { $_ -match '^([^=;\[]+)=' -and $upKeys -contains $Matches[1] })
                    if ($up.Count) { $upFrom = 'o de antes do mod' }
                }
                if (-not $up.Count) {
                    $up = @('bUpscalerSetByUser=False', 'bUpscalerDefaultsApplied=False')
                    $upFrom = 'o padrao do jogo para a placa'
                }
            }
            $out = New-Object System.Collections.Generic.List[string]
            $inserted = $false
            $upInserted = $false
            foreach ($line in $author) {
                if ($line -match '^([^=;\[]+)=' -and $keep -contains $Matches[1] -and $mine.Count) {
                    if (-not $inserted) { foreach ($m in $mine) { $out.Add($m) }; $inserted = $true }
                    continue
                }
                if ($up.Count -and $line -match '^([^=;\[]+)=' -and $upKeys -contains $Matches[1]) {
                    if (-not $upInserted) { foreach ($u in $up) { $out.Add($u) }; $upInserted = $true }
                    continue
                }
                $out.Add($line)
            }
            New-Item -ItemType Directory -Force (Split-Path $t -Parent) | Out-Null
            [IO.File]::WriteAllLines($t, $out, (New-Object Text.UTF8Encoding($false)))
            Note "config do autor: graficos do jogo em $t (resolucao/janela $(if ($mine.Count) { 'mantidas' } else { 'do autor' }); upscaler $(if ($up.Count) { $upFrom } else { 'do autor (FSR, placa AMD)' }))"
        }

        # 2) UEVR (config.txt/cameras.txt do perfil: Stereo Fix desligado, camera, mira...)
        $uevrDir = Join-Path $vr "dados\UnrealVRMod\$stem"
        New-Item -ItemType Directory -Force $uevrDir | Out-Null
        foreach ($f in (Get-ChildItem (Join-Path $cfg 'uevr') -File -ErrorAction SilentlyContinue)) {
            $dst = Join-Path $uevrDir $f.Name
            if (Test-Path $dst) { Copy-Item $dst (Join-Path $bak "uevr-$($f.Name)") }
            Copy-Item $f.FullName $dst -Force
        }
        # 3) opcoes do menu VR e calibracao do mod
        foreach ($f in (Get-ChildItem (Join-Path $cfg 'mod') -File -ErrorAction SilentlyContinue)) {
            $dst = Join-Path $plugins $f.Name
            if (Test-Path $dst) { Copy-Item $dst (Join-Path $bak "mod-$($f.Name)") }
            Copy-Item $f.FullName $dst -Force
        }
        Set-Content $stampFile $cfgHash -Encoding ascii
        Note "config do autor aplicada ($cfgHash); copias do que existia em $bak"
        $cfgApplied = $true
    } else {
        Note "config do autor: ja aplicada antes ($cfgHash), mantidos os ajustes atuais"
    }
}

# Game Pass: so o nucleo do fork + Native Stereo Fix mostram os dois olhos (testador, 23/10: com o nucleo normal ou sem o
# Stereo Fix, so o olho esquerdo). Ligados aqui a cada instalacao no Game Pass; na Steam nada muda.
$gamePass = $exeName -ne 'ValorMortis-Win64-Shipping.exe'
if ($gamePass -and (Test-Path (Join-Path $vr 'nucleo-fork\UEVRBackend.dll'))) {
    Set-Content (Join-Path $vr 'usar-nucleo-fork.txt') 'Game Pass: nucleo do fork ligado pelo instalador (nucleo-fork-DESLIGAR.bat desliga)' -Encoding ascii
    $ucfg = Join-Path $vr "dados\UnrealVRMod\$stem\config.txt"
    if (-not (Test-Path $ucfg)) {
        New-Item -ItemType Directory -Force (Split-Path $ucfg -Parent) | Out-Null
        Copy-Item (Join-Path $vr 'perfil\config.txt') $ucfg -Force
    }
    $lines = Get-Content $ucfg | ForEach-Object { $_ -replace '^VR_NativeStereoFix=.*', 'VR_NativeStereoFix=true' -replace '^VR_RenderingMethod=.*', 'VR_RenderingMethod=0' }
    if (-not ($lines -match '^VR_NativeStereoFix=')) { $lines += 'VR_NativeStereoFix=true' }
    [IO.File]::WriteAllLines($ucfg, [string[]]$lines, (New-Object Text.UTF8Encoding($false)))
    Note 'Game Pass: nucleo do fork e Native Stereo Fix ligados (dois olhos)'
    Write-Host 'Game Pass: nucleo do fork e Native Stereo Fix ligados (necessarios para os dois olhos no Game Pass).' -ForegroundColor Yellow
}

# Confere o que foi copiado
$bad = 0
foreach ($pair in @(
    @((Join-Path $files 'version.dll'), $dstVersion),
    @((Join-Path $files 'plugin\ValorMortisVR.dll'), (Join-Path $plugins 'ValorMortisVR.dll')),
    @((Join-Path $files 'ValorMortisVR\UEVRBackend.dll'), (Join-Path $vr 'UEVRBackend.dll')))) {
    if ((Get-FileHash $pair[0]).Hash -ne (Get-FileHash $pair[1]).Hash) { $bad++; Write-Host "Arquivo nao confere: $($pair[1])" -ForegroundColor Red; Note "nao confere: $($pair[1])" }
}
if ($bad) { Fail 'A copia falhou (antivirus bloqueando?). Tente de novo com o antivirus liberando a pasta do jogo.' }

# onde foi instalado (o coletar-logs e o desinstalar acham por aqui)
$state = Join-Path $env:LOCALAPPDATA 'ValorMortisVR'
New-Item -ItemType Directory -Force $state | Out-Null
Set-Content -Path (Join-Path $state 'pasta-do-jogo.txt') -Value $bin -Encoding utf8
Note "Instalado ok ($added ajustes novos, $kept mantidos)"

Write-Host ''
if ($update) { Write-Host 'Valor Mortis VR ATUALIZADO.' -ForegroundColor Green } else { Write-Host 'Valor Mortis VR INSTALADO.' -ForegroundColor Green }
Write-Host "Ajustes: $added novos, $kept mantidos (os seus)."
if ($cfgApplied) {
    Write-Host 'Configuracao do autor aplicada: graficos do jogo (FSR, qualidade), UEVR e opcoes do mod iguais as testadas.' -ForegroundColor Green
    Write-Host '  (a sua resolucao/janela foi mantida; copias do que havia antes ficaram guardadas)'
}
Write-Host ''
if ($store -eq 'Steam') { Write-Host 'Agora: ligue o headset (SteamVR, Oculus/Meta ou Virtual Desktop com OpenXR) e abra o jogo pela Steam.' }
else { Write-Host 'Agora: ligue o headset (SteamVR, Oculus/Meta ou Virtual Desktop com OpenXR) e abra o jogo pelo app Xbox.' }
Write-Host 'O VR liga sozinho uns 40 segundos depois do jogo abrir.'
Write-Host 'Se der algum problema: feche o jogo e rode coletar-logs.bat (nesta pasta); ele cria um ZIP na Area de Trabalho para mandar.'
