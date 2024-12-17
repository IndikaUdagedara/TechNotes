- Convert timestamp to ISO8601
  ```
  SELECT STRFTIME("%FT%R:%fZ", unixepoch('subsec'), 'unixepoch')
  -- unixepoch('subsec') - return current UTC time to sub second resolution
  ```