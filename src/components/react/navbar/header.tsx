import { Menu } from 'lucide-react';
import { useState } from 'react';

import MobileMenu from './mobile-menu';

import { navigation } from './navigation';

export default function Header() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const handleOpenMenu = () => {
    setIsMobileMenuOpen(true);
  };

  const handleCloseMenu = () => {
    setIsMobileMenuOpen(false);
  };

  return (
    <header className="absolute inset-x-0 top-0 z-50">
      <nav
        aria-label="Navigation principale"
        className="flex items-center justify-between p-6 lg:px-8"
      >
        <div className="flex lg:flex-1">
          <a href="/" className="-m-1.5 p-1.5">
            <span className="sr-only">Ligue des Alternants - Retour à l'accueil</span>
            <img src="/logo.png" alt="Logo Ligue des Alternants" className="h-11 w-auto" />
          </a>
        </div>

        <div className="flex lg:hidden">
          <button
            type="button"
            className="text-muted-foreground -m-2.5 inline-flex items-center justify-center rounded-md p-2.5"
            onClick={handleOpenMenu}
            aria-expanded={isMobileMenuOpen}
            aria-controls="mobile-menu"
            aria-label="Ouvrir le menu principal"
          >
            <Menu aria-hidden="true" className="size-6" />
          </button>
        </div>

        <NavItems />

        <div className="hidden lg:flex lg:flex-1 lg:justify-end"></div>

        {isMobileMenuOpen && <MobileMenu onCloseMenu={handleCloseMenu} />}
      </nav>
    </header>
  );
}

const NavItems = () => {
  const currentPath = typeof window !== 'undefined' ? window.location.pathname : '/';

  return (
    <div className="hidden lg:flex lg:gap-x-6">
      {navigation.map(({ href, name }) => {
        const isActive = currentPath === href;
        return (
          <a
            key={name}
            href={href}
            className="text-foreground hover:bg-accent hover:text-accent-foreground rounded-lg px-3 py-2 text-base/6 font-semibold transition-colors"
            aria-current={isActive ? 'page' : undefined}
          >
            {name}
          </a>
        );
      })}
    </div>
  );
};
