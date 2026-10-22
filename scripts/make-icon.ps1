# Genera images/icon.png: arriba "ÁL" y un cubo con los cuatro acentos en el contorno; abajo ">:LAB".
#   powershell -File scripts/make-icon.ps1                        # 128 px en images/icon.png
#   powershell -File scripts/make-icon.ps1 -Out prev.png -Size 512
# Solo Windows (System.Drawing). Los textos con tilde se escriben con [char] porque Windows PowerShell
# lee el script en ANSI. Ojo: las variables no distinguen mayúsculas ($c y $C son la misma).
param(
    [string]$Out = (Join-Path $PSScriptRoot "..\images\icon.png"),
    [int]$Size = 128,
    [string]$Prompt = ">:",
    [string]$PromptColor = "#5C8A52"
)
Add-Type -AssemblyName System.Drawing

# Se dibuja a 4x y se reduce al final: así también quedan suaves los bordes recortados.
$SS = 4
$S = $Size * $SS
$k = $S / 128.0
$bmp = New-Object System.Drawing.Bitmap $S, $S
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::Transparent)
function Hex($h) { [System.Drawing.ColorTranslator]::FromHtml($h) }
function Brush($h) { New-Object System.Drawing.SolidBrush (Hex $h) }
function Pt($x, $y) { New-Object System.Drawing.PointF ([single]$x), ([single]$y) }
function Seg($pen, $p1, $p2) { $g.DrawLine($pen, [single]$p1.X, [single]$p1.Y, [single]$p2.X, [single]$p2.Y) }

$family = New-Object System.Drawing.FontFamily "Cascadia Code SemiBold"
function GlyphPath($text) {
    # Winding: Cascadia es una fuente variable con contornos superpuestos; en modo Alternate saldrían huecos
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath ([System.Drawing.Drawing2D.FillMode]::Winding)
    $p.AddString($text, $family, 0, 100, (Pt 0 0), [System.Drawing.StringFormat]::GenericTypographic)
    return $p
}
# Contorno de $text con alto $h y esquina superior izquierda en ($x, $y)
function TextPath($text, $x, $y, $h) {
    $p = GlyphPath $text; $b = $p.GetBounds(); $s = $h / $b.Height
    $m = New-Object System.Drawing.Drawing2D.Matrix
    $m.Translate($x, $y); $m.Scale($s, $s); $m.Translate(-$b.X, -$b.Y)
    $p.Transform($m); return $p
}
function WidthAt($text, $h) { $b = (GlyphPath $text).GetBounds(); return $b.Width * $h / $b.Height }

# Fondo: cuadrado redondeado #121212 con borde #262626
$r = 24 * $k
$rect = New-Object System.Drawing.RectangleF (2 * $k), (2 * $k), ($S - 4 * $k), ($S - 4 * $k)
$bg = New-Object System.Drawing.Drawing2D.GraphicsPath
$bg.AddArc($rect.X, $rect.Y, $r, $r, 180, 90); $bg.AddArc($rect.Right - $r, $rect.Y, $r, $r, 270, 90)
$bg.AddArc($rect.Right - $r, $rect.Bottom - $r, $r, $r, 0, 90); $bg.AddArc($rect.X, $rect.Bottom - $r, $r, $r, 90, 90)
$bg.CloseFigure()
$g.FillPath((Brush "#121212"), $bg)
$g.DrawPath((New-Object System.Drawing.Pen (Hex "#262626"), (2 * $k)), $bg)

# Rejilla
$x0 = 18 * $k; $W = $S - 2 * $x0
$gapY = 12 * $k
$promptK = 0.62; $promptGap = 6 * $k

# Fila 2 manda: prompt + hueco + "LAB" ocupan W
$H2 = ($W - $promptGap) / ((WidthAt "LAB" 1) + (WidthAt $Prompt $promptK))

# Fila 1: "ÁL" y cubo, nunca más altos que "LAB"
$al = [string][char]0x00C1 + "L"
$cubeRatio = 2 / (2 * 0.5774 + 1.15)           # ancho / alto del cubo isométrico
$cubeK = 2.0                                   # el cubo, el doble de alto que "ÁL"
$H1 = [Math]::Min($H2 * 0.95, ($W - 10 * $k) / ((WidthAt $al 1) + $cubeRatio * $cubeK))
$cubeH = $H1 * $cubeK
# Si no cabe en vertical, se reduce todo (también las letras) y se centra el bloque en horizontal
$maxH = $S - 2 * 16 * $k
$fit = [Math]::Min(1, ($maxH - $gapY) / ($cubeH + $H2))
$H1 *= $fit; $H2 *= $fit; $cubeH *= $fit; $promptGap *= $fit
$x0 += $W * (1 - $fit) / 2; $W *= $fit
$top = ($S - ($cubeH + $gapY + $H2)) / 2

# "ÁL" en gris, a la izquierda y alineado por abajo con el cubo
$g.FillPath((Brush "#9D9D9D"), (TextPath $al $x0 ($top + $cubeH - $H1) $H1))

# Cubo isométrico, pegado al borde derecho
$a = $cubeH * $cubeRatio / 2; $q = $a * 0.5774; $L = $a * 1.15
$cx = $x0 + $W - $a; $y0 = $top
$T = Pt $cx $y0; $UL = Pt ($cx - $a) ($y0 + $q); $UR = Pt ($cx + $a) ($y0 + $q); $MID = Pt $cx ($y0 + 2 * $q)
$BL = Pt ($cx - $a) ($y0 + $q + $L); $BR = Pt ($cx + $a) ($y0 + $q + $L); $BOT = Pt $cx ($y0 + 2 * $q + $L)
$stroke = 2.8 * $k

# Caras grises
$g.FillPolygon((Brush "#3A3A3A"), [System.Drawing.PointF[]]@($T, $UR, $MID, $UL))
$g.FillPolygon((Brush "#2E2E2E"), [System.Drawing.PointF[]]@($UL, $MID, $BOT, $BL))
$g.FillPolygon((Brush "#242424"), [System.Drawing.PointF[]]@($MID, $UR, $BR, $BOT))

# Contorno: cuatro piezas sólidas unidas en inglete. El corte sigue la recta centro-esquina,
# que en un hexágono regular es la bisectriz del ángulo.
$hc = Pt $cx ($y0 + $q + $L / 2)               # centro del hexágono; apotema = $a
$corners = @($T, $UR, $BR, $BOT, $BL, $UL)
function Scaled($p, $f) { Pt ($hc.X + $f * ($p.X - $hc.X)) ($hc.Y + $f * ($p.Y - $hc.Y)) }
$fOut = ($a + $stroke / 2) / $a; $fIn = ($a - $stroke / 2) / $a
# tejado (UL-T-UR) fósforo, derecha azul, V inferior (BR-BOT-BL) magenta, izquierda violeta
$pieces = @(@(@(5, 0, 1), "#57C93F"), @(@(1, 2), "#0078D4"), @(@(2, 3, 4), "#FF4FA3"), @(@(4, 5), "#A07BFF"))
foreach ($piece in $pieces) {
    $idx = $piece[0]
    $outer = $idx | ForEach-Object { Scaled $corners[$_] $fOut }
    $inner = $idx[($idx.Count - 1)..0] | ForEach-Object { Scaled $corners[$_] $fIn }
    $g.FillPolygon((Brush $piece[1]), [System.Drawing.PointF[]]@($outer + $inner))
}

# Aristas delanteras (la "Y") en gris claro, por encima del contorno: llegan hasta el borde exterior
# y se recortan con la silueta del cubo, así quedan a ras.
$silhouette = New-Object System.Drawing.Drawing2D.GraphicsPath
$silhouette.AddPolygon([System.Drawing.PointF[]]@($corners | ForEach-Object { Scaled $_ $fOut }))
$g.SetClip($silhouette)
$front = New-Object System.Drawing.Pen (Hex "#CCCCCC"), $stroke
$front.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
function Beyond($p, $f) { Pt ($MID.X + $f * ($p.X - $MID.X)) ($MID.Y + $f * ($p.Y - $MID.Y)) }
foreach ($end in @($UL, $UR, $BOT)) { Seg $front $MID (Beyond $end 1.5) }
$g.ResetClip()

# Fila 2: prompt en verde apagado + "LAB"
$y2 = $top + $cubeH + $gapY
$promptH = $H2 * $promptK
$g.FillPath((Brush $PromptColor), (TextPath $Prompt $x0 ($y2 + $H2 - $promptH) $promptH))
$labX = $x0 + (WidthAt $Prompt $promptH) + $promptGap
$g.FillPath((Brush "#E8E8E8"), (TextPath "LAB" $labX $y2 $H2))
$g.Dispose()

# Reducción al tamaño final
$final = New-Object System.Drawing.Bitmap $Size, $Size
$gf = [System.Drawing.Graphics]::FromImage($final)
$gf.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gf.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$gf.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$gf.Clear([System.Drawing.Color]::Transparent)
$gf.DrawImage($bmp, 0, 0, $Size, $Size)
$gf.Dispose(); $bmp.Dispose()
$final.Save([System.IO.Path]::GetFullPath($Out), [System.Drawing.Imaging.ImageFormat]::Png)
$final.Dispose()
"ok $Out"
