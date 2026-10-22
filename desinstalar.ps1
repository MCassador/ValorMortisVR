# Tira o Valor Mortis VR da pasta do jogo (version.dll + pasta ValorMortisVR). Chamado pelo desinstalar.bat.
param([string]$GameBin = '', [switch]$Sim)
$ErrorActionPreference = 'Stop'
$exeName = 'ValorMortis-Win64-Shipping.exe'

function Fail($msg) { Write-Host ''; Write-Host $msg -ForegroundColor Red; exit 1 }

$bin = $GameBin.Trim('"')
# onde o instalador gravou (Steam ou Game Pass)
$state = Join-Path $env:LOCALAPPDATA 'ValorMortisVR\pasta-do-jogo.txt'
if (-not $bin -and (Test-Path $state)) { $bin = (Get-Content $state -Raw).Trim() }
if ($bin -and -not (Test-Path (Join-Path $bin 'ValorMortisVR'))) { $bin = '' }
if ($bin) { $found = Get-ChildItem -Path $bin -Filter 'ValorMortis*-Shipping.exe' -File -ErrorAction SilentlyContinue | Select-Object -First 1; if ($found) { $exeName = $found.Name } }
if (-not $bin) {
    $steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
    $libs = @()
    if ($steam) {
        $steam = $steam -replace '/', '\'
        $libs += $steam
        $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) { $libs += ($m.Groups[1].Value -replace '\\\\', '\') }
        }
    }
    foreach ($l in $libs) {
        $c = Join-Path $l 'steamapps\common\Valor Mortis\ValorMortis\Binaries\Win64'
        if (Test-Path (Join-Path $c $exeName)) { $bin = $c; break }
    }
}
if (-not $bin -or -not (Test-Path (Join-Path $bin $exeName))) {
    Write-Host 'Cole aqui a pasta Win64 do jogo:'
    $bin = (Read-Host 'Pasta').Trim('"')
    if (-not (Test-Path (Join-Path $bin $exeName))) { Fail "Nao achei $exeName nessa pasta." }
}
if (Get-Process -Name ([IO.Path]::GetFileNameWithoutExtension($exeName)) -ErrorAction SilentlyContinue) { Fail 'Feche o Valor Mortis antes.' }

Write-Host "Vai apagar version.dll e a pasta ValorMortisVR (com os seus ajustes) de: $bin"
if (-not $Sim) {
    $r = Read-Host 'Digite S para continuar'
    if ($r -notin 'S', 's') { Write-Host 'Cancelado.'; exit 0 }
}

Remove-Item (Join-Path $bin 'version.dll') -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $bin 'ValorMortisVR') -Recurse -Force -ErrorAction SilentlyContinue
$old = Join-Path $bin 'version.dll.antes-valormortisvr'
if (Test-Path $old) { Move-Item $old (Join-Path $bin 'version.dll') -Force; Write-Host 'O version.dll que existia antes foi devolvido.' }
Write-Host 'Valor Mortis VR removido.' -ForegroundColor Green
