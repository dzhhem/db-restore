#!/usr/bin/env bash
# ================================================================
#  db-restore.sh — PostgreSQL database restore
#  Reads connection details from .env
#  Usage: bash scripts/db-restore.sh                                                      (latest dump, default .env)
#         bash scripts/db-restore.sh --file dumps/db/backup-2026-04-09.sql               (specific dump)
#         bash scripts/db-restore.sh --env apps/api/.env                                 (custom .env)
#         bash scripts/db-restore.sh --reset                                             (drop & restore)
#         bash scripts/db-restore.sh --file dumps/db/backup.sql --env apps/api/.env --reset
# ================================================================

DUMP_FILE=""
ENV_FILE=".env"
RESET=false
DUMPS_DIR="dumps/db"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file)  DUMP_FILE="$2"; shift 2 ;;
    --env)   ENV_FILE="$2";  shift 2 ;;
    --reset) RESET=true;     shift   ;;
    *) echo "❌  Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$DUMP_FILE" ]]; then
  DUMP_FILE=$(ls -t "$DUMPS_DIR"/*.sql 2>/dev/null | head -1)
  if [[ -z "$DUMP_FILE" ]]; then
    echo "❌  No dump files found in $DUMPS_DIR" >&2; exit 1
  fi
  echo "📂  No dump specified, using latest: $DUMP_FILE"
fi

if [[ ! -f "$DUMP_FILE" ]]; then
  echo "❌  Dump file not found: $DUMP_FILE" >&2; exit 1
fi

if [[ -f "$ENV_FILE" ]]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo "❌  .env file not found: $ENV_FILE" >&2; exit 1
fi

if [[ -z "$DATABASE_URL" ]]; then
  echo "❌  DATABASE_URL is not set in $ENV_FILE" >&2; exit 1
fi

if [[ "$RESET" == "true" ]]; then
  echo "⚠️   Resetting database..."
  psql "$DATABASE_URL" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
fi

psql "$DATABASE_URL" < "$DUMP_FILE"

echo "✅  DB restored from → ./${DUMP_FILE}"