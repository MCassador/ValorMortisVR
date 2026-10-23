# Junta os registros do Valor Mortis VR num ZIP na Area de Trabalho (para mandar a quem fez o mod).
# Rode com o jogo FECHADO (o ultimo registro so termina de ser gravado quando o jogo fecha).
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$bin = $null
$state = Join-Path $env:LOCALAPPDATA 'ValorMortisVR\pasta-do-jogo.txt'
if (Test-Path $state) { $bin = (Get-Content $state -Raw).Trim() }
if (-not $bin -or -not (Test-Path (Join-Path $bin 'ValorMortisVR'))) {
    if (Test-Path (Join-Path $here 'UEVRBackend.dll')) { $bin = Split-Path -Parent $here }  # rodando de dentro de ValorMortisVR
}
if (-not $bin -or -not (Test-Path (Join-Path $bin 'ValorMortisVR'))) {
    Write-Host 'Nao achei a instalacao. Cole a pasta do executavel do jogo (onde fica o version.dll):'
    $bin = (Read-Host 'Pasta').Trim('"')
}
$vr = Join-Path $bin 'ValorMortisVR'
$tmp = Join-Path $env:TEMP ("valormortisvr-logs-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Force $tmp | Out-Null

function Grab($src, $name, [long]$tailBytes = 0) {
    if (-not (Test-Path $src)) { return }
    $dst = Join-Path $tmp $name
    $len = (Get-Item $src).Length
    if ($tailBytes -gt 0 -and $len -gt $tailBytes) {
        $fs = [IO.File]::Open($src, 'Open', 'Read', 'ReadWrite')
        $fs.Seek(-$tailBytes, 'End') | Out-Null
        $buf = New-Object byte[] $tailBytes
        $n = $fs.Read($buf, 0, $tailBytes)
        $fs.Close()
        [IO.File]::WriteAllBytes($dst, $buf[0..($n - 1)])
    } else {
        Copy-Item $src $dst -Force
    }
}

# instalacao, carregador e nucleo do VR
Grab (Join-Path $here 'relatorio-instalacao.txt') 'relatorio-instalacao.txt'
Grab (Join-Path (Split-Path -Parent $here) 'relatorio-instalacao.txt') 'relatorio-instalacao-2.txt'
Grab (Join-Path $vr 'loader.log') 'loader.log' 3MB
foreach ($d in (Get-ChildItem (Join-Path $vr 'dados\UnrealVRMod') -Directory -ErrorAction SilentlyContinue)) {
    Grab (Join-Path $d.FullName 'log.txt') "uevr-$($d.Name)-log.txt" 3MB
    Grab (Join-Path $d.FullName 'crash.dmp') "uevr-$($d.Name)-crash.dmp"
    Grab (Join-Path $d.FullName 'config.txt') "uevr-$($d.Name)-config.txt"
    Grab (Join-Path $d.FullName 'plugins\vmvr.log') "mod-$($d.Name)-vmvr.log" 5MB
    Grab (Join-Path $d.FullName 'plugins\opcoes-vr.txt') "mod-$($d.Name)-opcoes-vr.txt"
}
# registro do proprio jogo e configuracao grafica
$saveds = @(Join-Path $env:LOCALAPPDATA 'ValorMortis\Saved')
# Game Pass: o jogo grava na pasta virtual do pacote (Packages\...\LocalCache\Local\ValorMortis\Saved)
foreach ($pk in (Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Packages') -Directory -Filter '*ValorMortis*' -ErrorAction SilentlyContinue)) {
    $saveds += (Join-Path $pk.FullName 'LocalCache\Local\ValorMortis\Saved')
}
$k = 0
foreach ($saved in $saveds) {
    if (-not (Test-Path $saved)) { continue }
    $tag = if ($k -eq 0) { 'jogo' } else { "jogo$k" }
    $k++
    Grab (Join-Path $saved 'Logs\ValorMortis.log') "$tag-ValorMortis.log" 3MB
    foreach ($ini in (Get-ChildItem (Join-Path $saved 'Config') -Recurse -Filter '*.ini' -ErrorAction SilentlyContinue | Where-Object { $_.Name -in 'GameUserSettings.ini', 'Engine.ini', 'Scalability.ini' })) {
        Grab $ini.FullName "$tag-$($ini.Directory.Name)-$($ini.Name)"
    }
    Add-Content (Join-Path $tmp 'pasta-do-jogo.txt') "Saved ($tag): $saved" -Encoding utf8 -ErrorAction SilentlyContinue
}
# placa de video
try { Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, AdapterRAM | Format-List | Out-String | Set-Content (Join-Path $tmp 'placa-de-video.txt') -Encoding utf8 } catch {}
# arquivos da pasta do jogo (nomes e tamanhos)
Get-ChildItem $bin -File -ErrorAction SilentlyContinue | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-String |
    Set-Content (Join-Path $tmp 'pasta-do-jogo.txt') -Encoding utf8
Add-Content (Join-Path $tmp 'pasta-do-jogo.txt') "Pasta: $bin" -Encoding utf8

$zip = Join-Path ([Environment]::GetFolderPath('Desktop')) ("ValorMortisVR-logs-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.zip')
Compress-Archive -Path (Join-Path $tmp '*') -DestinationPath $zip -Force
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ''
Write-Host "Pronto: $zip" -ForegroundColor Green
Write-Host 'Mande esse arquivo para quem fez o mod.'
