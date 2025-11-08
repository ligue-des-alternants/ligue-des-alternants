import { Linkedin } from '@lucide/astro';

import InstagramIcon from './icons/instagram-icon.astro';
import TikTokIcon from './icons/tiktok-icon.astro';
import XIcon from './icons/x-icon.astro';

export const socialLinks = [
  {
    name: 'Facebook',
    url: 'https://x.com/LigueAlternants',
    icon: XIcon,
  },
  {
    name: 'Instagram',
    url: 'https://www.instagram.com/ligue.des.alternants',
    icon: InstagramIcon,
  },
  {
    name: 'TikTok',
    url: 'https://www.tiktok.com/@ligue.des.alternants',
    icon: TikTokIcon,
  },
  {
    name: 'LinkedIn',
    url: 'https://www.linkedin.com/company/ligue-des-alternants/',
    icon: Linkedin,
  },
];
