# Instala o Valor Mortis VR na pasta do jogo (Steam). Chamado pelo instalar.bat.
# Uso: instalar.bat            -> acha o jogo sozinho
#      instalar.bat "D:\...\ValorMortis\Binaries\Win64"   -> pasta indicada por voce
param([string]$GameBin = '')
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$files = Join-Path $here 'arquivos'
$exeName = 'ValorMortis-Win64-Shipping.exe'

function Fail($msg) { Write-Host ''; Write-Host $msg -ForegroundColor Red; exit 1 }

function Find-GameBin {
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
        if (Test-Path (Join-Path $bin $exeName)) { return $bin }
    }
    return $null
}

Write-Host '=== Valor Mortis VR - instalador ===' -ForegroundColor Cyan
if (-not (Test-Path (Join-Path $files 'version.dll'))) {
    Fail 'Pasta "arquivos" nao encontrada. Extraia o ZIP inteiro antes de rodar o instalador.'
}

if ($GameBin) { $bin = $GameBin.Trim('"') } else { $bin = Find-GameBin }
if (-not $bin -or -not (Test-Path (Join-Path $bin $exeName))) {
    Write-Host 'Nao achei o Valor Mortis nas bibliotecas da Steam.' -ForegroundColor Yellow
    Write-Host 'Cole aqui a pasta Win64 do jogo (ex.: D:\SteamLibrary\steamapps\common\Valor Mortis\ValorMortis\Binaries\Win64):'
    $bin = (Read-Host 'Pasta').Trim('"')
    if (-not (Test-Path (Join-Path $bin $exeName))) { Fail "Nao achei $exeName nessa pasta." }
}
Write-Host "Jogo encontrado em: $bin"

if (Get-Process -Name 'ValorMortis-Win64-Shipping' -ErrorAction SilentlyContinue) {
    Fail 'Feche o Valor Mortis antes de instalar.'
}

$vr = Join-Path $bin 'ValorMortisVR'
$plugins = Join-Path $vr 'dados\UnrealVRMod\ValorMortis-Win64-Shipping\plugins'
$update = Test-Path (Join-Path $plugins 'ValorMortisVR.dll')

# Se ja existia outro version.dll (de outro mod), guarda uma copia antes de trocar.
$dstVersion = Join-Path $bin 'version.dll'
$srcVersion = Join-Path $files 'version.dll'
if ((Test-Path $dstVersion) -and ((Get-FileHash $dstVersion).Hash -ne (Get-FileHash $srcVersion).Hash)) {
    $bak = Join-Path $bin 'version.dll.antes-valormortisvr'
    if (-not (Test-Path $bak)) { Copy-Item $dstVersion $bak; Write-Host 'Copia do version.dll antigo: version.dll.antes-valormortisvr' }
}

New-Item -ItemType Directory -Force (Join-Path $vr 'perfil') | Out-Null
New-Item -ItemType Directory -Force $plugins | Out-Null

Copy-Item $srcVersion $dstVersion -Force
foreach ($f in 'UEVRBackend.dll', 'openxr_loader.dll', 'LuaVR.dll') {
    Copy-Item (Join-Path $files "ValorMortisVR\$f") (Join-Path $vr $f) -Force
}
Copy-Item (Join-Path $files 'ValorMortisVR\perfil\config.txt') (Join-Path $vr 'perfil\config.txt') -Force
Copy-Item (Join-Path $files 'plugin\ValorMortisVR.dll') (Join-Path $plugins 'ValorMortisVR.dll') -Force

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
    if ((Get-FileHash $pair[0]).Hash -ne (Get-FileHash $pair[1]).Hash) { $bad++; Write-Host "Arquivo nao confere: $($pair[1])" -ForegroundColor Red }
}
if ($bad) { Fail 'A copia falhou (antivirus bloqueando?). Tente de novo com o antivirus liberando a pasta do jogo.' }

Write-Host ''
if ($update) { Write-Host 'Valor Mortis VR ATUALIZADO.' -ForegroundColor Green } else { Write-Host 'Valor Mortis VR INSTALADO.' -ForegroundColor Green }
Write-Host "Ajustes: $added novos, $kept mantidos (os seus)."
Write-Host ''
Write-Host 'Agora: ligue o headset (SteamVR, Oculus/Meta ou Virtual Desktop com OpenXR) e abra o jogo pela Steam.'
Write-Host 'O VR liga sozinho junto com o jogo.'
