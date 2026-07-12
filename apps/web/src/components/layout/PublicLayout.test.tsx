import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import { PublicLayout } from "./PublicLayout";

describe("PublicLayout", () => {
  it("exposes a working skip link to the main landmark", () => {
    render(
      <PublicLayout>
        <p>content</p>
      </PublicLayout>,
    );

    const skipLink = screen.getByRole("link", {
      name: "Skip to main content",
    });
    expect(skipLink).toHaveAttribute("href", "#main-content");

    const main = screen.getByRole("main");
    expect(main).toHaveAttribute("id", "main-content");
  });

  it("renders header and footer landmarks", () => {
    render(
      <PublicLayout>
        <p>content</p>
      </PublicLayout>,
    );

    expect(screen.getByRole("banner")).toBeVisible();
    expect(screen.getByRole("contentinfo")).toBeVisible();
  });
});
