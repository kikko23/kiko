# Kiko Odds Lab 7.0 - Windows App

Prototype applicatif pour le projet FOOT / Kiko Odds Lab.

## Stack recommandée
- Windows 11
- Node.js LTS
- Electron + Vite + React + TypeScript
- SQLite local pour la base de données
- Tesseract.js pour OCR image/PDF exporté en image
- Recharts pour graphiques
- Lucide React pour icônes génériques

## Modules
- Dashboard
- Match Center
- Ma Sélection
- Best Tips
- Import Center
- Analytics
- Data Engineering

## Installation Windows
```powershell
cd apps/kiko-odds-lab-v7
npm install
npm run dev
```

## Priorité actuelle
Créer le Data Engine SQLite avant de connecter le live, les PDF ou les icônes d'équipes.

## Note importante
Les données bookmaker doivent être importées via PDF/capture/saisie manuelle avec validation humaine. Ne pas construire de scraping agressif.
