-- KIKO ODDS LAB 7.0 - SQLite Data Engine
-- Base locale Windows pour FOOT.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('manual','pdf','image_ocr','csv','api')),
  url TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS competitions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  country TEXT,
  external_id TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS teams (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  short_name TEXT,
  country TEXT,
  logo_url TEXT,
  external_id TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS matches (
  id TEXT PRIMARY KEY,
  competition_id TEXT REFERENCES competitions(id),
  home_team_id TEXT NOT NULL REFERENCES teams(id),
  away_team_id TEXT NOT NULL REFERENCES teams(id),
  kickoff TEXT NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('upcoming','live','finished','postponed','cancelled')) DEFAULT 'upcoming',
  home_score INTEGER,
  away_score INTEGER,
  source_id TEXT REFERENCES sources(id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS odds (
  id TEXT PRIMARY KEY,
  match_id TEXT NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  source_id TEXT REFERENCES sources(id),
  bookmaker TEXT,
  market TEXT NOT NULL,
  odd_value REAL NOT NULL,
  collected_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS selections (
  id TEXT PRIMARY KEY,
  match_id TEXT NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  market TEXT NOT NULL,
  market_probability REAL,
  kiko_probability REAL,
  edge REAL,
  risk_level TEXT CHECK(risk_level IN ('VERT','JAUNE','ORANGE','ROUGE')),
  decision TEXT CHECK(decision IN ('GO','WATCH','NON')),
  confidence INTEGER CHECK(confidence BETWEEN 1 AND 5),
  favorite INTEGER NOT NULL DEFAULT 0,
  note TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS betslips (
  id TEXT PRIMARY KEY,
  name TEXT,
  type TEXT NOT NULL CHECK(type IN ('simple','combine','systeme')),
  stake REAL NOT NULL DEFAULT 0,
  total_odd REAL,
  potential_return REAL,
  status TEXT NOT NULL CHECK(status IN ('active','won','lost','cashed_out','void')) DEFAULT 'active',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  settled_at TEXT
);

CREATE TABLE IF NOT EXISTS betslip_items (
  id TEXT PRIMARY KEY,
  betslip_id TEXT NOT NULL REFERENCES betslips(id) ON DELETE CASCADE,
  selection_id TEXT NOT NULL REFERENCES selections(id),
  odd_value REAL NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('pending','won','lost','void')) DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS bankroll_transactions (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL CHECK(type IN ('deposit','withdrawal','stake','win','loss','cashout','correction')),
  amount REAL NOT NULL,
  betslip_id TEXT REFERENCES betslips(id),
  note TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS import_jobs (
  id TEXT PRIMARY KEY,
  source_id TEXT REFERENCES sources(id),
  filename TEXT NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('pending','review','validated','rejected','error')) DEFAULT 'pending',
  raw_text TEXT,
  error_message TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  validated_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_matches_kickoff ON matches(kickoff);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);
CREATE INDEX IF NOT EXISTS idx_odds_match ON odds(match_id);
CREATE INDEX IF NOT EXISTS idx_selections_match ON selections(match_id);
CREATE INDEX IF NOT EXISTS idx_betslips_status ON betslips(status);
