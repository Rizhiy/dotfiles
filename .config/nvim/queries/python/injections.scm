; extends
(assignment
  left: (identifier) @name (#any-of? @name "sql" "query")
  right: (string (string_content) @injection.content)
  (#set! injection.language "sql")
  (#set! injection.combined))
