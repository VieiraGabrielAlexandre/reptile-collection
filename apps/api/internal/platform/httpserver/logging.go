package httpserver

import (
	"log/slog"
	"net/http"
	"time"
)

// requestLoggingMiddleware logs one structured completion event per request.
// It intentionally does not log request or response bodies, headers, or
// query strings, which may contain sensitive data.
func requestLoggingMiddleware(logger *slog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			recorder := &statusRecorder{ResponseWriter: w, statusCode: http.StatusOK}

			next.ServeHTTP(recorder, r)

			logger.InfoContext(r.Context(), "request completed",
				"method", r.Method,
				"route", r.URL.Path,
				"status", recorder.statusCode,
				"duration_ms", time.Since(start).Milliseconds(),
				"correlation_id", CorrelationIDFromContext(r.Context()),
			)
		})
	}
}

type statusRecorder struct {
	http.ResponseWriter
	statusCode int
}

func (r *statusRecorder) WriteHeader(statusCode int) {
	r.statusCode = statusCode
	r.ResponseWriter.WriteHeader(statusCode)
}
