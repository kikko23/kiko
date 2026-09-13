import React from 'react';
import { createRoot } from 'react-dom/client';
import {
  BarChart3,
  Bell,
  CalendarDays,
  Database,
  Download,
  FileText,
  LineChart,
  Settings,
  Star,
  Trophy,
  Wallet,
  Wifi,
  CheckCircle2,
  XCircle,
  HelpCircle,
  Search,
  Plus,
  CircleDot,
} from 'lucide-react';
import './styles.css';

type Risk = 'VERT' | 'JAUNE' | 'ORANGE' | 'ROUGE';
type Decision = 'GO' | '?' | 'NON';

type Match = {
  id: string;
  date: string;
  hour: string;
  competition: string;
  home: string;
  away: string;
  odds1: number;
  oddsN: number;
  odds2: number;
  market: string;
  fair: number;
  risk: Risk;
  decision: Decision;
  confidence: string;
  favorite: boolean;
};

const matches: Match[] = [
  { id: 'm1', date: '05/09', hour: '19:00', competition: 'Europa League', home: 'AEK Athènes', away: 'Aris Salonique', odds1: 1.61, oddsN: 3.8, odds2: 5.2, market: '1X2', fair: 88, risk: 'JAUNE', decision: 'GO', confidence: '4/5', favorite: true },
  { id: 'm2', date: '05/09', hour: '19:45', competition: 'Serie A', home: 'AS Rome', away: 'Atalanta', odds1: 1.95, oddsN: 3.4, odds2: 3.75, market: '1X2', fair: 81, risk: 'JAUNE', decision: '?', confidence: '3/5', favorite: false },
  { id: 'm3', date: '05/09', hour: '20:00', competition: 'LaLiga', home: 'Villarreal', away: 'La Corogne', odds1: 1.45, oddsN: 4.2, odds2: 6.1, market: '1X2', fair: 84, risk: 'VERT', decision: 'GO', confidence: '5/5', favorite: true },
  { id: 'm4', date: '05/09', hour: '20:30', competition: 'Liga Portugal', home: 'Sporting CP', away: 'CD Nacional', odds1: 1.28, oddsN: 5.4, odds2: 11.0, market: 'DC (1X)', fair: 93, risk: 'VERT', decision: 'GO', confidence: '4/5', favorite: true },
  { id: 'm5', date: '06/09', hour: '15:15', competition: 'Premier League', home: 'Valence', away: 'FC Barcelone', odds1: 7.2, oddsN: 5.2, odds2: 1.3, market: '1X2', fair: 70, risk: 'ORANGE', decision: '?', confidence: '3/5', favorite: false },
  { id: 'm6', date: '08/09', hour: '20:00', competition: 'Champions League', home: 'Real Madrid', away: 'Inter Milan', odds1: 1.56, oddsN: 4.2, odds2: 5.0, market: '1X2', fair: 81, risk: 'JAUNE', decision: '?', confidence: '4/5', favorite: false },
];

const riskClass: Record<Risk, string> = {
  VERT: 'risk-green',
  JAUNE: 'risk-yellow',
  ORANGE: 'risk-orange',
  ROUGE: 'risk-red',
};

const decisionClass: Record<Decision, string> = {
  GO: 'decision-go',
  '?': 'decision-watch',
  NON: 'decision-no',
};

function App() {
  const selected = matches.find((match) => match.home === 'Sporting CP') ?? matches[0];

  return (
    <main className="app-shell">
      <aside className="sidebar">
        <div className="brand"><div className="ball">⚽</div><div><strong>KIKO ODDS LAB</strong><span>FOOT</span></div></div>
        <SideSection title="Match Center" icon={<CircleDot />} items={[['Upcoming', '24'], ['Live', '3'], ['Finished', '12'], ['Calendrier', '']]} />
        <SideSection title="Mes Sélections" icon={<Star />} items={[['Mes paris', '8'], ['Watchlist', '5'], ['Rejetés', '3'], ['Suivi', '']]} />
        <SideSection title="Best Tips" icon={<Trophy />} items={[['Tips du jour', '4'], ['Historique', '58'], ['Statistiques', '']]} />
        <SideSection title="Import Center" icon={<Download />} items={[['Fichiers CSV', '2'], ['PDF Bookmaker', ''], ['Capture OCR', ''], ['Saisie manuelle', '']]} />
        <SideSection title="Analytics" icon={<LineChart />} items={[['Performance', ''], ['Bankroll', ''], ['Statistiques avancées', ''], ['Rapports', '']]} />
        <SideSection title="Data Engineering" icon={<Database />} items={[['Sources données', ''], ['Traitements', ''], ['Logs système', '']]} />
        <footer>KIKO ODDS LAB v7.0.0<br />Build Windows alpha</footer>
      </aside>

      <section className="workspace">
        <header className="topbar">
          {['Dashboard', 'Match Center', 'Ma Sélection', 'Best Tips', 'Import Center', 'Analytics', 'Data Engineering'].map((item, index) => (
            <button key={item} className={index === 0 ? 'tab active' : 'tab'}>{item}</button>
          ))}
          <div className="top-actions"><Search size={18} /><input placeholder="Rechercher un match, une équipe..." /><Settings /><Bell /><span className="base-ok">● Base OK</span></div>
        </header>

        <section className="kpis">
          <Kpi icon={<CalendarDays />} label="Match Review" value="66" delta="+12 cette semaine" />
          <Kpi icon={<CheckCircle2 />} label="Sélections" value="28" delta="42% du total" />
          <Kpi icon={<BarChart3 />} label="ROI global" value="+12.4%" delta="30 derniers jours" />
          <Kpi icon={<Wallet />} label="Bankroll" value="1 245 €" delta="+154 € (+14.1%)" />
          <Kpi icon={<Wifi />} label="Match Live" value="3" delta="En cours" danger />
        </section>

        <section className="panel match-center">
          <div className="panel-head"><div><h1>Match Center</h1><p>Analysez, comparez et sélectionnez les meilleures opportunités.</p></div><button className="primary"><Plus size={18} /> Ajouter un match</button></div>
          <div className="filters"><button className="pill active">Tous (24)</button><button className="pill">Aujourd'hui (8)</button><button className="pill">Demain (12)</button><button className="pill">Cette semaine (24)</button><select><option>Compétition : Toutes</option></select><select><option>Risque : Tous</option></select><select><option>Décision : Tous</option></select></div>
          <table>
            <thead><tr><th>★</th><th>Date</th><th>Heure</th><th>Compétition</th><th>Équipe domicile</th><th>Équipe extérieur</th><th>1</th><th>N</th><th>2</th><th>Marché</th><th>FAIR</th><th>Risque</th><th>Décision</th><th>Confiance</th><th>Actions</th></tr></thead>
            <tbody>{matches.map((match) => <MatchRow key={match.id} match={match} />)}</tbody>
          </table>
        </section>

        <section className="lower-grid">
          <article className="panel review"><h2>Match Review</h2><div className="versus"><div><div className="crest">SCP</div><strong>{selected.home}</strong><span>Domicile</span></div><b>vs</b><div><div className="crest away">CDN</div><strong>{selected.away}</strong><span>Extérieur</span></div></div><div className="odd-grid"><Stat label="Cote 1" value={selected.odds1.toString()} /><Stat label="Cote N" value={selected.oddsN.toString()} /><Stat label="Cote 2" value={selected.odds2.toString()} /><Stat label="Probabilité 1" value="72%" /><Stat label="Probabilité N" value="18%" /><Stat label="Probabilité 2" value="10%" /></div><p className="info">Bonne opportunité détectée sur Sporting CP. La cote proposée est supérieure à notre estimation.</p></article>
          <article className="panel tip"><h2>Best Tip du jour</h2><strong>Sporting CP vs CD Nacional</strong><span className="badge green">MEILLEURE VALEUR</span><dl><dt>Cote bookmaker</dt><dd>1.28</dd><dt>Cote équitable</dt><dd>1.39</dd><dt>Valeur</dt><dd>+8.6%</dd><dt>Risque</dt><dd><span className="risk risk-yellow">JAUNE</span></dd></dl></article>
          <article className="panel chart"><h2>Graphique des probabilités</h2><div className="bars"><i style={{height:'72%'}}>72%</i><i style={{height:'18%'}}>18%</i><i style={{height:'10%'}}>10%</i></div><div className="mini-line"></div></article>
          <article className="panel bankroll"><h2>Bankroll</h2><strong>1 245 €</strong><span className="positive">+14.1%</span><p>Mise totale : 870 €<br />Gain total : +154 €<br />Paris gagnants : 42 (58%)</p></article>
        </section>
      </section>
    </main>
  );
}

function Kpi({ icon, label, value, delta, danger = false }: { icon: React.ReactNode; label: string; value: string; delta: string; danger?: boolean }) {
  return <article className={danger ? 'kpi danger' : 'kpi'}><div className="kpi-icon">{icon}</div><div><span>{label}</span><strong>{value}</strong><small>{delta}</small></div></article>;
}

function SideSection({ title, icon, items }: { title: string; icon: React.ReactNode; items: string[][] }) {
  return <nav className="side-section"><h3>{icon}{title}</h3>{items.map(([label, count]) => <button key={label}>{label}{count && <span>{count}</span>}</button>)}</nav>;
}

function MatchRow({ match }: { match: Match }) {
  return <tr><td>{match.favorite ? '⭐' : '☆'}</td><td>{match.date}</td><td>{match.hour}</td><td>{match.competition}</td><td>{match.home}</td><td>{match.away}</td><td>{match.odds1}</td><td>{match.oddsN}</td><td>{match.odds2}</td><td>{match.market}</td><td className="fair">{match.fair}%</td><td><span className={`risk ${riskClass[match.risk]}`}>{match.risk}</span></td><td><span className={`decision ${decisionClass[match.decision]}`}>{match.decision}</span></td><td>{match.confidence}</td><td><FileText size={16} /></td></tr>;
}

function Stat({ label, value }: { label: string; value: string }) {
  return <div className="stat"><span>{label}</span><strong>{value}</strong></div>;
}

createRoot(document.getElementById('root')!).render(<App />);
