// Command api runs the reptile-collection HTTP API.
package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"

	"github.com/VieiraGabrielAlexandre/reptile-collection/apps/api/internal/platform/config"
	"github.com/VieiraGabrielAlexandre/reptile-collection/apps/api/internal/platform/httpserver"
)

func main() {
	if err := run(); err != nil {
		slog.Error("application exited with error", "error", err)
		os.Exit(1)
	}
}

func run() error {
	cfg, err := config.Load()
	if err != nil {
		return err
	}

	logger := newLogger(cfg)
	slog.SetDefault(logger)

	logger.Info("application starting")

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	router := httpserver.NewRouter(logger)

	return httpserver.Run(ctx, logger, ":"+cfg.HTTP.Port, router)
}

func newLogger(cfg config.Config) *slog.Logger {
	var level slog.Level
	if err := level.UnmarshalText([]byte(cfg.Log.Level)); err != nil {
		level = slog.LevelInfo
	}

	handler := slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: level})

	return slog.New(handler).With(
		"service", "reptile-collection-api",
		"environment", cfg.Environment,
	)
}
