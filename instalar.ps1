# Instala o Valor Mortis VR na pasta do jogo (Steam ou Xbox Game Pass). Chamado pelo instalar.bat.
# Uso: instalar.bat            -> acha o jogo sozinho (Steam e Game Pass)
#      instalar.bat "D:\...\ValorMortis\Binaries\Win64"   -> pasta indicada por voce (a pasta do executavel do jogo)
# Grava um relatorio (relatorio-instalacao.txt, ao lado deste arquivo) para mandar se algo der errado.
param([string]$GameBin = '')
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
} catch {
    Fail "A copia falhou: $($_.Exception.Message)"
}

# Ajustes e calibracao: so entram se ainda nao existirem (uma atualizacao nunca apaga o que voce ajustou).
$kept = 0; $added = 0
foreach ($f in Get-ChildItem (Join-Path $files 'padroes') -File) {
    $dst = Join-Path $plugins $f.Name
    if (Test-Path $dst) { $kept++ } else { Copy-Item $f.FullName $dst; $added++ }
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
Write-Host ''
if ($store -eq 'Steam') { Write-Host 'Agora: ligue o headset (SteamVR, Oculus/Meta ou Virtual Desktop com OpenXR) e abra o jogo pela Steam.' }
else { Write-Host 'Agora: ligue o headset (SteamVR, Oculus/Meta ou Virtual Desktop com OpenXR) e abra o jogo pelo app Xbox.' }
Write-Host 'O VR liga sozinho uns 40 segundos depois do jogo abrir.'
Write-Host 'Se der algum problema: feche o jogo e rode coletar-logs.bat (nesta pasta); ele cria um ZIP na Area de Trabalho para mandar.'
