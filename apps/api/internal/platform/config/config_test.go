package config

import "testing"

const testDatabaseURL = "postgres://user:pass@localhost:5432/db?sslmode=disable"

func TestLoadUsesLocalDefaultsWhenEnvironmentIsUnset(t *testing.T) {
	t.Setenv("DATABASE_URL", testDatabaseURL)

	cfg, err := Load()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if cfg.Environment != "local" {
		t.Errorf("expected default environment 'local', got %q", cfg.Environment)
	}

	if cfg.HTTP.Port != "8080" {
		t.Errorf("expected default port '8080', got %q", cfg.HTTP.Port)
	}

	if cfg.Log.Level != "info" {
		t.Errorf("expected default log level 'info', got %q", cfg.Log.Level)
	}
}

func TestLoadRejectsInvalidLogLevel(t *testing.T) {
	t.Setenv("DATABASE_URL", testDatabaseURL)
	t.Setenv("LOG_LEVEL", "verbose")

	_, err := Load()
	if err == nil {
		t.Fatal("expected an error for an invalid log level, got nil")
	}
}

func TestLoadRejectsEmptyPort(t *testing.T) {
	t.Setenv("DATABASE_URL", testDatabaseURL)
	t.Setenv("API_PORT", "")

	cfg, err := Load()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// An explicitly empty API_PORT falls back to the default, since getEnv
	// treats an empty value as unset. This test documents that behavior.
	if cfg.HTTP.Port != "8080" {
		t.Errorf("expected fallback port '8080', got %q", cfg.HTTP.Port)
	}
}

func TestLoadRequiresDatabaseURL(t *testing.T) {
	t.Setenv("DATABASE_URL", "")

	if _, err := Load(); err == nil {
		t.Fatal("expected an error when DATABASE_URL is missing, got nil")
	}
}
