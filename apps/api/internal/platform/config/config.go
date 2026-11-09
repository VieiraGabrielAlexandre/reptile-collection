// Package config centralizes environment-based configuration loading for the API.
package config

import (
	"fmt"
	"os"
)

// Config is the typed, validated configuration for the API process.
type Config struct {
	Environment string
	HTTP        HTTPConfig
	Log         LogConfig
	Database    DatabaseConfig
}

// DatabaseConfig configures the PostgreSQL connection.
type DatabaseConfig struct {
	// URL is a PostgreSQL connection string. It contains credentials and
	// must never be logged.
	URL string
}

// HTTPConfig configures the HTTP server.
type HTTPConfig struct {
	Port string
}

// LogConfig configures structured logging.
type LogConfig struct {
	Level string
}

var allowedLogLevels = map[string]struct{}{
	"debug": {},
	"info":  {},
	"warn":  {},
	"error": {},
}

// Load reads configuration from environment variables, applies local-safe
// defaults, and validates the result. It fails fast on invalid values.
func Load() (Config, error) {
	cfg := Config{
		Environment: getEnv("APP_ENV", "local"),
		HTTP: HTTPConfig{
			Port: getEnv("API_PORT", "8080"),
		},
		Log: LogConfig{
			Level: getEnv("LOG_LEVEL", "info"),
		},
		Database: DatabaseConfig{
			URL: os.Getenv("DATABASE_URL"),
		},
	}

	if err := cfg.validate(); err != nil {
		return Config{}, fmt.Errorf("load config: %w", err)
	}

	return cfg, nil
}

func (c Config) validate() error {
	if c.HTTP.Port == "" {
		return fmt.Errorf("API_PORT must not be empty")
	}

	if _, ok := allowedLogLevels[c.Log.Level]; !ok {
		return fmt.Errorf("LOG_LEVEL %q is not one of debug, info, warn, error", c.Log.Level)
	}

	if c.Database.URL == "" {
		return fmt.Errorf("DATABASE_URL must be set")
	}

	return nil
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok && value != "" {
		return value
	}

	return fallback
}
