# =====================================================================
#  Renderiza las piezas del Sanding Stick a STL, desde PowerShell.
#  Equivalente a render.sh, para no necesitar Git Bash ni WSL.
#
#    .\render.ps1                 -> v1, calidad final ($fn=64)  -> stl\v1\
#    .\render.ps1 v2              -> solo la v2                  -> stl\v2\
#    .\render.ps1 todas           -> las cinco versiones
#    .\render.ps1 v2 preview      -> rapido ($fn=48)             -> preview_stl\v2\
#
#  Si OpenSCAD no esta en el PATH, se busca en las rutas habituales de
#  instalacion. Tambien puedes decirlo a mano:
#    $env:OPENSCAD = "D:\apps\OpenSCAD\openscad.exe"; .\render.ps1 v2
# =====================================================================
param(
    [string]$Version = "v1",
    [string]$Modo    = "final"
)
$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

# ---- localizar openscad ---------------------------------------------
$candidatos = @()
if ($env:OPENSCAD) { $candidatos += $env:OPENSCAD }
$cmd = Get-Command openscad.exe -ErrorAction SilentlyContinue
if ($cmd) { $candidatos += $cmd.Source }
$candidatos += "$env:ProgramFiles\OpenSCAD\openscad.exe"
$candidatos += "${env:ProgramFiles(x86)}\OpenSCAD\openscad.exe"
$candidatos += "$env:LOCALAPPDATA\Programs\OpenSCAD\openscad.exe"

$OPENSCAD = $candidatos | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1
if (-not $OPENSCAD) {
    Write-Host "ERROR: no encuentro openscad.exe." -ForegroundColor Red
    Write-Host "  Instalalo desde https://openscad.org/downloads.html, o indica la ruta:"
    Write-Host '    $env:OPENSCAD = "C:\ruta\a\openscad.exe"; .\render.ps1 v2'
    exit 1
}
Write-Host "OpenSCAD: $OPENSCAD"

# ---- parametros de la tanda -----------------------------------------
if ($Modo -eq "preview") { $FN = 48; $RAIZ = "preview_stl" } else { $FN = 64; $RAIZ = "stl" }
$versiones = if ($Version -eq "todas") { @("v1","v2","v3","v4","v5") } else { @($Version) }

function Scad-De([string]$v) {
    if ($v -eq "v1") { "scad\sanding_stick.scad" } else { "scad\sanding_stick_$v.scad" }
}

$fallos = 0
foreach ($v in $versiones) {
    $scad = Scad-De $v
    if (-not (Test-Path -LiteralPath $scad)) { Write-Host "ERROR: no existe $scad" -ForegroundColor Red; exit 1 }
    $out = Join-Path $RAIZ $v
    New-Item -ItemType Directory -Force -Path $out | Out-Null
    Write-Host "-- $v  ($scad)"

    function Render([string]$nombre, [string[]]$defs) {
        $destino = Join-Path $out "$nombre.stl"
        Write-Host "   . $nombre"
        $args = @("--export-format","binstl","-o",$destino,"-D","`$fn=$FN")
        foreach ($d in $defs) { $args += @("-D", $d) }
        $args += $scad
        & $OPENSCAD @args 2>&1 | Where-Object { $_ -match "ERROR" } | ForEach-Object { Write-Host "     $_" -ForegroundColor Yellow }
        if (-not (Test-Path -LiteralPath $destino) -or (Get-Item -LiteralPath $destino).Length -eq 0) {
            Write-Host "     FALLO: no se ha escrito $destino" -ForegroundColor Red
            $script:fallos++
        }
    }

    foreach ($m in @("recta","ergonomica","doble")) {
        Render "mango_$m" @('pieza="mango"', "variante_mango=`"$m`"")
    }
    foreach ($w in @(8,16)) {
        foreach ($a in @(0,45,90)) {
            Render "cabezal_pala_${w}_$a" @('pieza="cabezal"','tipo="pala"',"ancho=$w","angulo=$a")
        }
        foreach ($t in @("triangulo","prisma_tri","medio_tubo_convexo","medio_tubo_concavo")) {
            Render "cabezal_${t}_$w" @('pieza="cabezal"',"tipo=`"$t`"","ancho=$w")
        }
    }
    Render "test_ajuste" @('pieza="test_ajuste"')
}

if ($fallos -gt 0) { Write-Host "Terminado con $fallos piezas sin escribir." -ForegroundColor Red; exit 1 }
$n = (Get-ChildItem -Path $RAIZ -Recurse -Filter *.stl).Count
Write-Host "Listo. $n STL en $RAIZ\"
