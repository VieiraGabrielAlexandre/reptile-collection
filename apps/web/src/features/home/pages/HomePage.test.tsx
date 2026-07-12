import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import { HomePage } from "./HomePage";

describe("HomePage", () => {
  it("renders the platform name as the main heading", () => {
    render(<HomePage />);

    expect(
      screen.getByRole("heading", { name: "Reptile Collection", level: 1 }),
    ).toBeVisible();
  });

  it("communicates that the catalog is not available yet", () => {
    render(<HomePage />);

    expect(screen.getByText(/not available yet/i)).toBeVisible();
  });
});
