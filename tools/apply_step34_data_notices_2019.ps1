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

# 2019 als offizielle Parlamentswahl in allen Datenhinweisen ergänzen.
foreach ($file in $files) {
  $content = Get-Content $file -Raw -Encoding UTF8

  $content = $content -replace "source\.type == ElectionSourceType\.parliamentary2025 \|\|\s*source\.type == ElectionSourceType\.parliamentary2021", "source.type == ElectionSourceType.parliamentary2025 ||`r`n        source.type == ElectionSourceType.parliamentary2021 ||`r`n        source.type == ElectionSourceType.parliamentary2019"

  $content = $content -replace "selectedSource\.type == ElectionSourceType\.parliamentary2025 \|\|\s*selectedSource\.type == ElectionSourceType\.parliamentary2021", "selectedSource.type == ElectionSourceType.parliamentary2025 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2021 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2019"

  # Falls eine ältere Variante nur 2025 enthält.
  $content = $content -replace "source\.type == ElectionSourceType\.parliamentary2025;", "source.type == ElectionSourceType.parliamentary2025 ||`r`n        source.type == ElectionSourceType.parliamentary2021 ||`r`n        source.type == ElectionSourceType.parliamentary2019;"

  $content = $content -replace "selectedSource\.type == ElectionSourceType\.parliamentary2025;", "selectedSource.type == ElectionSourceType.parliamentary2025 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2021 ||`r`n        selectedSource.type == ElectionSourceType.parliamentary2019;"

  Set-Content $file $content -Encoding UTF8
}

Write-Host "Datenhinweise für Parlamentare 2019 wurden ergänzt."
