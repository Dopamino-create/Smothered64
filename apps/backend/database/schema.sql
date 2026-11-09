CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    username VARCHAR(30) NOT NULL,

    email VARCHAR(255) UNIQUE NOT NULL,

    password_hash TEXT NOT NULL,

    avatar_url TEXT,

    rating INTEGER NOT NULL DEFAULT 1200,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    white_player_id UUID NOT NULL
        REFERENCES users(id),

    black_player_id UUID
        REFERENCES users(id),

    status VARCHAR(20) NOT NULL DEFAULT 'waiting'
        CHECK (status IN ('waiting', 'active', 'completed', 'abandoned')),

    result VARCHAR(20)
        CHECK (result IN ('white', 'black', 'draw')),

    time_control VARCHAR(30),

    initial_fen TEXT,

    final_fen TEXT,

    pgn TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

CREATE INDEX IF NOT EXISTS idx_games_white_player
ON games(white_player_id);

CREATE INDEX IF NOT EXISTS idx_games_black_player
ON games(black_player_id);

CREATE INDEX IF NOT EXISTS idx_games_created_at
ON games(created_at DESC);