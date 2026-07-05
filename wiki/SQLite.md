# SQLite
## Timestamp Conversion

Convert timestamp to ISO8601:

```sql
SELECT STRFTIME("%FT%R:%fZ", unixepoch('subsec'), 'unixepoch')
-- unixepoch('subsec') - return current UTC time to sub second resolution
```

## Database Operations

### Open Database

```bash
sqlite3 <filename>
```

### Show Schema

List all tables:

```sql
.tables
```

Show schema of a specific table:

```sql
.schema <table-name>
```
