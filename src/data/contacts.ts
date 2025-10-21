import { House, MessageCircleQuestionMark, Phone } from '@lucide/astro';

export const contacts = [
  {
    title: 'Votre tuteur ou RH',
    description: 'Premier point de contact en entreprise.',
    Icon: MessageCircleQuestionMark,
  },
  { title: 'Le centre de formation', description: 'Pour les questions pédagogiques.', Icon: House },
  { title: 'Inspection du travail', description: 'En cas de litige grave.', Icon: Phone },
];
