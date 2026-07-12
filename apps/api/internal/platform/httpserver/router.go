// Package httpserver wires HTTP middleware, routing, and server lifecycle.
package httpserver

import (
	"log/slog"
	"net/http"

	"github.com/go-chi/chi/v5"
	chimiddleware "github.com/go-chi/chi/v5/middleware"

	"github.com/VieiraGabrielAlexandre/reptile-collection/apps/api/internal/platform/health"
)

// NewRouter builds the application's HTTP router with the baseline
// middleware chain: panic recovery, correlation ID, then request logging.
func NewRouter(logger *slog.Logger) http.Handler {
	router := chi.NewRouter()

	router.Use(chimiddleware.Recoverer)
	router.Use(correlationMiddleware)
	router.Use(requestLoggingMiddleware(logger))

	healthHandler := health.NewHandler()
	router.Get("/health", healthHandler.Health)
	router.Get("/ready", healthHandler.Ready)

	return router
}
