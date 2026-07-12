export function Header() {
  return (
    <header className="border-b border-[var(--color-border)] bg-[var(--color-surface)]">
      <div className="mx-auto flex max-w-5xl items-center justify-between px-4 py-4">
        <a href="/" className="text-lg font-semibold tracking-tight">
          Reptile Collection
        </a>
      </div>
    </header>
  );
}
