- Convert timestamp to ISO8601
  ```
  SELECT STRFTIME("%FT%R:%fZ", unixepoch('subsec'), 'unixepoch')
  -- unixepoch('subsec') - return current UTC time to sub second resolution
  ```
- open database
	- `sqlite3 <filename>`
- show schema
	- ```
	  # list all tables
	  > .tables 
	  
	   # schema of table
	  > .schema <table-name>
	  ```
-