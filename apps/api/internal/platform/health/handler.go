// Package health provides the liveness and readiness HTTP handlers.
package health

import (
	"context"
	"encoding/json"
	"log/slog"
	"net/http"
	"time"
)

// readinessTimeout bounds each dependency check so /ready stays cheap.
const readinessTimeout = 2 * time.Second

// Pinger is an essential dependency whose availability gates readiness.
// The PostgreSQL pool (*pgxpool.Pool) satisfies it.
type Pinger interface {
	Ping(ctx context.Context) error
}

// Handler serves /health and /ready.
type Handler struct {
	logger   *slog.Logger
	database Pinger
}

// NewHandler creates a health Handler. database is the essential dependency
// checked by /ready.
func NewHandler(logger *slog.Logger, database Pinger) Handler {
	return Handler{logger: logger, database: database}
}

type statusResponse struct {
	Status string            `json:"status"`
	Checks map[string]string `json:"checks,omitempty"`
}

// Health confirms the process is alive. It must not depend on external
// services.
func (h Handler) Health(w http.ResponseWriter, r *http.Request) {
	writeStatus(w, http.StatusOK, statusResponse{Status: "ok"})
}

// Ready confirms the application can receive traffic: every essential
// dependency must answer within readinessTimeout. Failure details are logged,
// never returned to the client.
func (h Handler) Ready(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), readinessTimeout)
	defer cancel()

	if err := h.database.Ping(ctx); err != nil {
		h.logger.WarnContext(r.Context(), "readiness check failed", "dependency", "database", "error", err)
		writeStatus(w, http.StatusServiceUnavailable, statusResponse{
			Status: "unavailable",
			Checks: map[string]string{"database": "unavailable"},
		})

		return
	}

	writeStatus(w, http.StatusOK, statusResponse{
		Status: "ready",
		Checks: map[string]string{"database": "ok"},
	})
}

func writeStatus(w http.ResponseWriter, statusCode int, body statusResponse) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	_ = json.NewEncoder(w).Encode(body)
}
