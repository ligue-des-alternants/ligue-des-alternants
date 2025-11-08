import { Calendar, Clock, Euro, ShieldCheck, UserCheck } from '@lucide/astro';

export const rights = [
  { title: 'Rémunération', description: 'Salaire minimum selon la loi.', Icon: Euro },
  { title: 'Congés payés', description: '2,5 jours/mois.', Icon: Calendar },
  { title: 'Temps de travail', description: 'Respect du code du travail.', Icon: Clock },
  { title: 'Encadrement', description: 'Tuteur dédié.', Icon: UserCheck },
  { title: 'Protection sociale', description: 'Sécurité sociale, retraite…', Icon: ShieldCheck },
];
