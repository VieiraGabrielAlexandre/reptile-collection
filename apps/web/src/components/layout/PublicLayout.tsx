import type { ReactNode } from "react";
import { Header } from "./Header";
import { Footer } from "./Footer";

interface PublicLayoutProps {
  children: ReactNode;
}

export function PublicLayout({ children }: PublicLayoutProps) {
  return (
    <div className="flex min-h-screen flex-col">
      <a
        href="#main-content"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:rounded focus:bg-[var(--color-accent)] focus:px-4 focus:py-2 focus:text-[var(--color-accent-foreground)]"
      >
        Skip to main content
      </a>

      <Header />

      <main id="main-content" tabIndex={-1} className="flex-1">
        {children}
      </main>

      <Footer />
    </div>
  );
}
