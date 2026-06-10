$ErrorActionPreference = "Stop"

$files = @(
  "lib\src\features\home\presentation\home_screen.dart",
  "lib\src\features\results\presentation\results_screen.dart",
  "lib\src\features\candidates\presentation\candidates_screen.dart",
  "lib\src\features\municipalities\presentation\municipalities_screen.dart"
)

foreach ($file in $files) {
  if (-not (Test-Path $file)) {
    throw "Datei nicht gefunden: $file"
  }
}

foreach ($file in $files) {
  $content = Get-Content $file -Raw -Encoding UTF8

  # Ergänzt 2014 in bestehende offizielle Parlamentswahl-Prüfungen.
  $content = $content -replace "source\.type == ElectionSourceType\.parliamentary2025 \|\|\s*source\.type == ElectionSourceType\.parliamentary2021 \|\|\s*source\.type == ElectionSourceType\.parliamentary2019", "source.type == ElectionSourceType.parliamentary2025 ||`r`n        source.type == ElectionSourceType.parliamentary2021 ||`r`n        source.type == ElectionSourceType.parliamentary2019 ||`r`n        source.type == ElectionSourceType.parliamentary2014"

  $content = $content -replace "selectedSource\.type == ElectionSourceType\.parliamentary2025 \|\|\s*selectedSource\.type == ElectionSourceType\.parliamentary2021 \|\|\s*selectedSource\.type == ElectionSourceType\.parliamentary2019", "selectedSource.type == ElectionSourceType.parliamentary2025 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2021 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2019 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2014"

  # Falls durch frühere Dateien 2014 schon drin ist, nichts doppelt tun.
  $content = $content -replace "ElectionSourceType\.parliamentary2014 \|\|\s*source\.type == ElectionSourceType\.parliamentary2014", "ElectionSourceType.parliamentary2014"
  $content = $content -replace "ElectionSourceType\.parliamentary2014 \|\|\s*selectedSource\.type == ElectionSourceType\.parliamentary2014", "ElectionSourceType.parliamentary2014"

  Set-Content $file $content -Encoding UTF8
}

Write-Host "Datenhinweise für Parlamentare 2014 wurden ergänzt."
