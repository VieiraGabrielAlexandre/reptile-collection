export function HomePage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-16">
      <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">
        Reptile Collection
      </h1>
      <p className="mt-4 text-lg text-[var(--color-foreground)]/80">
        A structured, source-attributed knowledge base about reptile
        species — their taxonomy, ecology, conservation, and role in the
        natural world.
      </p>
      <p className="mt-6 text-[var(--color-foreground)]/70">
        This platform is under active foundational development. The species
        catalog, search, and articles described in the project roadmap are
        not available yet.
      </p>
    </div>
  );
}
