# KIKO ODDS LAB 7.0 - FOOT

## Vision
Kiko Odds Lab 7.0 devient un logiciel Windows local pour suivre, analyser et historiser les paris football : import PDF/capture, favoris, cotes, résultats, bankroll, ROI et décisions GO / ? / NON.

Objectif : ne pas copier un bookmaker. L'application doit devenir le centre de pilotage personnel : importer, contrôler, sélectionner, suivre, mesurer, apprendre.

## Navigation cible

### Top navigation
- Dashboard
- Match Center
- Ma Sélection
- Best Tips
- Import Center
- Analytics
- Data Engineering

### Sidebar gauche
- Match Center
  - Upcoming
  - Live
  - Finished
  - Calendrier
- Mes Sélections
  - Mes paris
  - Watchlist
  - Rejetés
  - Suivi
- Best Tips
  - Tips du jour
  - Historique
  - Statistiques
- Import Center
  - Fichiers CSV
  - PDF / Bookmakers
  - Capture OCR
  - Saisie manuelle
  - Historique import
- Analytics
  - Performance
  - Bankroll
  - Statistiques avancées
  - Rapports
- Data Engineering
  - Sources de données
  - Traitements
  - Logs système

## KPIs du dashboard
- Match Review : nombre de matchs analysés et nouveaux matchs de la semaine
- Sélections : nombre de GO, Watchlist, Rejetés
- ROI global : rendement sur 7/30/90 jours
- Bankroll : solde, gains, pertes, mises ouvertes
- Match Live : matchs en cours et alertes

## Objets métier

### Match
Une rencontre sportive unique. Toutes les cotes, sélections, résultats et notes doivent se rattacher à un seul match.

Champs recommandés :
- id
- competition_id
- home_team_id
- away_team_id
- kickoff
- status : upcoming, live, finished, postponed, cancelled
- home_score
- away_score
- source_id
- created_at
- updated_at

### Odds
Historique des cotes par match et par source.

Champs recommandés :
- id
- match_id
- source_id
- bookmaker
- market : 1, N, 2, 1X, X2, 12, over, under
- odd_value
- collected_at

### Selection
Décision Kiko sur un match.

Champs recommandés :
- id
- match_id
- market
- market_probability
- kiko_probability
- edge
- risk_level : VERT, JAUNE, ORANGE, ROUGE
- decision : GO, WATCH, NON
- confidence : 1 à 5
- favorite : true/false
- note
- created_at

### BetSlip
Coupon de paris.

Champs recommandés :
- id
- name
- type : simple, combine, systeme
- stake
- total_odd
- potential_return
- status : active, won, lost, cashed_out, void
- created_at
- settled_at

### BankrollTransaction
Journal financier.

Champs recommandés :
- id
- type : deposit, withdrawal, stake, win, loss, cashout, correction
- amount
- betslip_id
- note
- created_at

## Règles FAIR
FAIR ne doit pas être présenté comme une prédiction IA si la donnée provient uniquement des cotes normalisées.

Séparer clairement :
- Probabilité marché : dérivée des cotes
- Probabilité Kiko : estimation interne ou modèle futur
- Edge : différence entre probabilité Kiko et probabilité marché

## Sources acceptées
- Saisie manuelle
- PDF ou capture bookmaker avec validation humaine
- CSV historiques football-data
- API football/résultats si configurée

## Règle importante
Aucun scraping agressif de bookmaker. L'import PDF/capture doit rester piloté par l'utilisateur avec validation manuelle.

## Priorité de réalisation
1. Data Engine SQLite local
2. Import Center PDF / image / CSV
3. Match Center
4. BetSlip + bankroll
5. Results Engine
6. Analytics
7. UI premium Windows
