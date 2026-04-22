# DB Restore

`db-restore.sh` is a simple Bash script for restoring PostgreSQL database dumps. It automatically reads connection details from your `.env` file — no manual input required.

## Features

- **Auto Configuration:** Reads `DATABASE_URL` from `.env`.
- **Safe `.env` Parsing:** Correctly handles inline comments and quoted values.
- **Flexible ENV Path:** Accepts a custom path to `.env` file via `-e` / `--env` argument.
- **Auto Latest:** Automatically uses the most recent dump if no file is specified.
- **Docker Support:** Automatically detects Docker environment and replaces `localhost` with the `postgres` service name.
- **Prisma Compatibility:** Strips Prisma-specific query parameters (e.g. `?schema=public`) unsupported by `psql`.
- **Error Handling:** Exits with a non-zero code if the connection or restore fails — no false success messages.
- **Named Arguments:** Supports short (`-f`, `-e`, `-r`) and long (`--file`, `--env`, `--reset`) flags.
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
bash scripts/db-restore.sh -e apps/api/.env
```

### Restore specific dump with default `.env`
```bash
bash scripts/db-restore.sh -f dumps/db/backup-2026-04-09_14-30-00.sql
```

### Restore specific dump with custom `.env`
```bash
bash scripts/db-restore.sh -f dumps/db/backup-2026-04-09_14-30-00.sql -e apps/api/.env
```

### Restore with full database reset
```bash
bash scripts/db-restore.sh -e apps/api/.env --reset
```

### Run inside Docker (via runner container)
```bash
bash scripts/db-restore.sh -e apps/api/.env.docker
```

## .env configuration

The following variable must be present in your `.env` file:
```
DATABASE_URL=postgresql://postgres:your_password@localhost:5432/your_db?schema=public
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