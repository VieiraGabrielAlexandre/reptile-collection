package httpserver

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"time"
)

// shutdownTimeout bounds how long an in-flight request may delay shutdown.
const shutdownTimeout = 10 * time.Second

// Run starts the HTTP server and blocks until ctx is cancelled, then
// performs a graceful shutdown. It returns a non-nil error only on an
// unexpected startup or shutdown failure.
func Run(ctx context.Context, logger *slog.Logger, addr string, handler http.Handler) error {
	server := &http.Server{
		Addr:    addr,
		Handler: handler,
	}

	serveErr := make(chan error, 1)

	go func() {
		logger.Info("HTTP server listening", "addr", addr)

		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			serveErr <- err
			return
		}

		serveErr <- nil
	}()

	select {
	case err := <-serveErr:
		return err
	case <-ctx.Done():
		logger.Info("shutdown signal received, starting graceful shutdown")

		shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
		defer cancel()

		if err := server.Shutdown(shutdownCtx); err != nil {
			return err
		}

		logger.Info("graceful shutdown complete")

		return nil
	}
}
