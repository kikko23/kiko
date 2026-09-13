Write-Host "KIKO ODDS LAB 7.0 - Setup Windows" -ForegroundColor Cyan

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host "Node.js n'est pas installé. Installe Node.js LTS depuis https://nodejs.org/ puis relance ce script." -ForegroundColor Yellow
  exit 1
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  Write-Host "npm n'est pas disponible. Réinstalle Node.js LTS." -ForegroundColor Red
  exit 1
}

Write-Host "Node:" (node -v) -ForegroundColor Green
Write-Host "npm:" (npm -v) -ForegroundColor Green

npm install
npm run dev
