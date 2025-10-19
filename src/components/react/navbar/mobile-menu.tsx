import { useEffect, useRef } from 'react';

import { X } from 'lucide-react';

import { navigation } from './navigation';

interface MobileMenuProps {
  onCloseMenu: () => void;
}

export default function MobileMenu({ onCloseMenu }: MobileMenuProps) {
  const menuRef = useRef<HTMLDivElement>(null);
  const closeButtonRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    // Focus the close button when the menu opens
    closeButtonRef.current?.focus();

    // Handle Escape key
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onCloseMenu();
      }
    };

    // Handle focus trap
    const handleTab = (e: KeyboardEvent) => {
      if (e.key !== 'Tab' || !menuRef.current) return;

      const focusableElements = menuRef.current.querySelectorAll<HTMLElement>(
        'a[href], button:not([disabled])'
      );
      const firstElement = focusableElements[0];
      const lastElement = focusableElements[focusableElements.length - 1];

      if (e.shiftKey && document.activeElement === firstElement) {
        e.preventDefault();
        lastElement?.focus();
      } else if (!e.shiftKey && document.activeElement === lastElement) {
        e.preventDefault();
        firstElement?.focus();
      }
    };

    document.addEventListener('keydown', handleEscape);
    document.addEventListener('keydown', handleTab);

    // Prevent body scroll
    document.body.style.overflow = 'hidden';

    return () => {
      document.removeEventListener('keydown', handleEscape);
      document.removeEventListener('keydown', handleTab);
      document.body.style.overflow = '';
    };
  }, [onCloseMenu]);

  return (
    <div className="lg:hidden" role="dialog" aria-modal="true" aria-label="Menu mobile">
      <div className="fixed inset-0 z-50 bg-black/50" onClick={onCloseMenu} aria-hidden="true" />
      <div
        id="mobile-menu"
        ref={menuRef}
        className="bg-background sm:ring-border fixed inset-y-0 right-0 z-50 w-full overflow-y-auto p-6 sm:max-w-sm sm:ring-1"
      >
        <div className="flex items-center justify-between">
          <a href="/" className="-m-1.5 p-1.5">
            <span className="sr-only">Ligue des Alternants - Retour à l'accueil</span>
            <img src="/logo.png" alt="Logo Ligue des Alternants" className="h-11 w-auto" />
          </a>
          <button
            ref={closeButtonRef}
            type="button"
            className="text-muted-foreground -m-2.5 rounded-md p-2.5"
            onClick={onCloseMenu}
            aria-label="Fermer le menu"
          >
            <X aria-hidden="true" className="size-6" />
          </button>
        </div>
        <div className="mt-6 flow-root">
          <div className="-my-6">
            <div className="space-y-2 py-6">
              {navigation.map(({ href, name }) => {
                return <NavItem key={name} href={href} name={name} />;
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

const NavItem = ({ href, name }: { href: string; name: string }) => {
  const currentPath = typeof window !== 'undefined' ? window.location.pathname : '/';
  const isActive = currentPath === href;

  return (
    <a
      key={name}
      className="text-foreground hover:bg-accent hover:text-accent-foreground block rounded-lg px-3 py-2 text-base/7 font-semibold transition-colors"
      href={href}
      aria-current={isActive ? 'page' : undefined}
    >
      {name}
    </a>
  );
};
