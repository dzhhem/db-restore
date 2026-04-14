# DB Restore

`db-restore.sh` is a simple Bash script for restoring PostgreSQL database dumps. It automatically reads connection details from your `.env` file — no manual input required.

## Features

- **Auto Configuration:** Reads `DATABASE_URL` from `.env`.
- **Flexible ENV Path:** Accepts a custom path to `.env` file via `--env` argument.
- **Auto Latest:** Automatically uses the most recent dump if no file is specified.
- **Named Arguments:** Supports `--file`, `--env` and `--reset` flags for explicit control.
- **Reset Mode:** Optionally drops and recreates the schema before restoring for a clean slate.

## Usage

Ensure the script is executable:
```bash
chmod +x scripts/db-restore.sh
```

### Restore latest dump with default `.env`
```bash
bash scripts/db-restore.sh
```

### Restore latest dump with custom `.env`
```bash
bash scripts/db-restore.sh --env apps/api/.env
```

### Restore specific dump with default `.env`
```bash
bash scripts/db-restore.sh --file dumps/db/backup-2026-04-09_14-30-00.sql
```

### Restore specific dump with custom `.env`
```bash
bash scripts/db-restore.sh --file dumps/db/backup-2026-04-09_14-30-00.sql --env apps/api/.env
```

### Restore with full database reset
```bash
bash scripts/db-restore.sh --env apps/api/.env --reset
```

## .env configuration

The following variable must be present in your `.env` file:
```
DATABASE_URL=postgresql://postgres:your_password@localhost:5432/your_db
```

## Requirements

- `bash`
- `psql` (comes with PostgreSQL)

## .gitignore recommendation

Add the following to your `.gitignore` to avoid committing dump files:
```
# Dumps (e.g. database dumps, codebase dumps, etc.)
dumps/
```