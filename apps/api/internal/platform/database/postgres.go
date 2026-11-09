// Package database owns the PostgreSQL connection pool for the API.
package database

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

// NewPool parses the connection string and creates a connection pool.
//
// pgxpool connects lazily, so the API process can start while PostgreSQL is
// still unavailable; /ready reports the dependency state instead of the
// process failing at startup. Errors never include the connection string,
// because it contains credentials.
func NewPool(ctx context.Context, url string) (*pgxpool.Pool, error) {
	poolConfig, err := pgxpool.ParseConfig(url)
	if err != nil {
		return nil, fmt.Errorf("parse DATABASE_URL: invalid connection string")
	}

	pool, err := pgxpool.NewWithConfig(ctx, poolConfig)
	if err != nil {
		return nil, fmt.Errorf("create database pool: %w", err)
	}

	return pool, nil
}
