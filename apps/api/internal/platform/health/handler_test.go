package health

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"testing"
)

// fakePinger is an in-memory stand-in for the database pool.
type fakePinger struct{ err error }

func (f fakePinger) Ping(context.Context) error { return f.err }

func newTestHandler(database Pinger) Handler {
	return NewHandler(slog.New(slog.NewTextHandler(io.Discard, nil)), database)
}

func decode(t *testing.T, response *httptest.ResponseRecorder) statusResponse {
	t.Helper()

	var body statusResponse
	if err := json.NewDecoder(response.Body).Decode(&body); err != nil {
		t.Fatalf("failed to decode response body: %v", err)
	}

	return body
}

func TestHealthReturnsOKEvenWhenDatabaseIsDown(t *testing.T) {
	handler := newTestHandler(fakePinger{err: errors.New("connection refused")})

	response := httptest.NewRecorder()
	handler.Health(response, httptest.NewRequest(http.MethodGet, "/health", nil))

	if response.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", response.Code)
	}

	if body := decode(t, response); body.Status != "ok" {
		t.Errorf("expected status 'ok', got %q", body.Status)
	}
}

func TestReadyReturnsReadyWhenDatabaseAnswers(t *testing.T) {
	handler := newTestHandler(fakePinger{})

	response := httptest.NewRecorder()
	handler.Ready(response, httptest.NewRequest(http.MethodGet, "/ready", nil))

	if response.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", response.Code)
	}

	body := decode(t, response)
	if body.Status != "ready" || body.Checks["database"] != "ok" {
		t.Errorf("unexpected body: %+v", body)
	}
}

func TestReadyReturnsUnavailableWithoutLeakingErrorDetails(t *testing.T) {
	handler := newTestHandler(fakePinger{err: errors.New("dial tcp 10.0.0.5:5432: secret-detail")})

	response := httptest.NewRecorder()
	handler.Ready(response, httptest.NewRequest(http.MethodGet, "/ready", nil))

	if response.Code != http.StatusServiceUnavailable {
		t.Fatalf("expected status 503, got %d", response.Code)
	}

	body := decode(t, response)
	if body.Status != "unavailable" || body.Checks["database"] != "unavailable" {
		t.Errorf("unexpected body: %+v", body)
	}
}
