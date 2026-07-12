package httpserver

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"net/http"
	"regexp"
)

// CorrelationHeader is the single stable header name used for request
// correlation across logs and responses.
const CorrelationHeader = "X-Correlation-ID"

type contextKey string

const correlationIDContextKey contextKey = "correlationID"

// validCorrelationID accepts short, opaque, safe identifiers only. It
// deliberately rejects anything containing control characters, line breaks,
// or excessive length, since the incoming header value is not trusted.
var validCorrelationID = regexp.MustCompile(`^[A-Za-z0-9-]{8,64}$`)

// correlationMiddleware assigns a correlation ID to every request: it
// reuses a valid incoming header value, or generates a new one. The value is
// stored in the request context and echoed back in the response header.
func correlationMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		id := r.Header.Get(CorrelationHeader)
		if !validCorrelationID.MatchString(id) {
			id = generateCorrelationID()
		}

		ctx := context.WithValue(r.Context(), correlationIDContextKey, id)
		w.Header().Set(CorrelationHeader, id)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// CorrelationIDFromContext returns the correlation ID stored by
// correlationMiddleware, or an empty string when none is present.
func CorrelationIDFromContext(ctx context.Context) string {
	id, _ := ctx.Value(correlationIDContextKey).(string)
	return id
}

func generateCorrelationID() string {
	buf := make([]byte, 16)
	if _, err := rand.Read(buf); err != nil {
		// crypto/rand.Read failing indicates a broken system entropy
		// source; a fixed fallback keeps the request flowing rather than
		// panicking on an otherwise successful request.
		return "unavailable-entropy"
	}

	return hex.EncodeToString(buf)
}
