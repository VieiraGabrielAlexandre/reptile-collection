// Package health provides the liveness and readiness HTTP handlers.
package health

import (
	"encoding/json"
	"net/http"
)

// Handler serves /health and /ready.
//
// /ready currently reports the same result as /health because no external
// dependency (database, cache, storage) is wired into the application yet.
// It must gain a real dependency check when the first essential dependency
// (PostgreSQL) is introduced, rather than continuing to report unconditional
// readiness.
type Handler struct{}

// NewHandler creates a health Handler.
func NewHandler() Handler {
	return Handler{}
}

type statusResponse struct {
	Status string `json:"status"`
}

// Health confirms the process is alive. It must not depend on external
// services.
func (h Handler) Health(w http.ResponseWriter, r *http.Request) {
	writeStatus(w, http.StatusOK, "ok")
}

// Ready confirms the application can receive traffic. See the Handler
// doc comment for its current, temporary limitation.
func (h Handler) Ready(w http.ResponseWriter, r *http.Request) {
	writeStatus(w, http.StatusOK, "ready")
}

func writeStatus(w http.ResponseWriter, statusCode int, status string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	_ = json.NewEncoder(w).Encode(statusResponse{Status: status})
}
