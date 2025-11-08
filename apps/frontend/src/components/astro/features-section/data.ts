import { Route, Trophy, Wrench } from '@lucide/astro';

export const features = [
  {
    title: 'Des outils pour réussir votre alternance',
    description:
      "Guides pratiques, conseils d'experts et outils pour booster votre parcours en alternance et développer vos compétences.",
    Icon: Wrench,
  },
  {
    title: 'Accompagner les parcours de A à Z',
    description:
      "De l'orientation à l'emploi, nous vous soutenons à chaque étape de votre parcours en alternance.",
    Icon: Route,
  },
  {
    title: "Valoriser l'alternance et les talents",
    description:
      "Témoignages inspirants, réussites célébrées et entreprises engagées pour donner vie à votre parcours d'alternant.",
    Icon: Trophy,
  },
] as const;
